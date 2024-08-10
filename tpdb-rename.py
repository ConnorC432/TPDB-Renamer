import argparse
import os
import re


#TV Directory Class
class TvDirs:
    def __init__(self, tv_dirs_array):
        self.dir_array = tv_dirs_array

    def rename_dir_array(self):
        #Previously renamed file regex
        renamed_image = re.compile(r'(season-specials-poster|show|Season.*|.*S.*E.*)\.(png|jpg|jpeg)')

        #Rename all directories in array
        print(f"Renaming {len(self.dir_array)} TV directories...")
        for directory in self.dir_array:
            #Skip invalid directories
            if not os.path.isdir(directory):
                print(f"\033[1mSkipping invalid directory:\033[0m {directory}")
                continue

            # Rename valid directories
            print(f"Renaming {directory}...")
            for root, dirs, files in os.walk(directory):
                for file in files:
                    #Skip previously renamed files
                    if renamed_image.match(file):
                        continue

                    base_name, ext = os.path.splitext(file)
                    ext = ext[1:]

                    season_pattern = re.compile(r'(.*?) - Season ([0-9]+)\.(png|jpg|jpeg)')
                    specials_pattern = re.compile(r'(.*?) - Specials\.(png|jpg|jpeg)')

                    print("test3")
                    #Rename Season Images
                    if season_pattern.match(file):
                        match = season_pattern.match(file)
                        new_name = f"Season {match.group(2)}.{match.group(3)}"
                        print("test1")

                    #Rename Special Images
                    elif specials_pattern.match(file):
                        match = specials_pattern.match(file)
                        new_name = f"season-specials-poster.{match.group(2)}"
                        print("test2")

                    else:
                        new_name = f"show.{ext}"

                    if new_name:
                        old_file_path = os.path.join(root, file)
                        new_file_path = os.path.join(root, new_name)

                        #Rename File
                        print(f"Renaming {old_file_path} to {new_file_path}...")
                        os.rename(old_file_path, new_file_path)


#Film Directory Class
class FilmDirs:
    def __init__(self, film_dirs_array):
        self.dir_array = film_dirs_array

    def rename_dir_array(self):
        #Previously renamed file regex
        renamed_image = re.compile(r'.*poster\.(png|jpg|jpeg)', re.IGNORECASE)

        #Rename all directories in array
        print(f"Renaming {len(self.dir_array)} Film directories...")
        for directory in self.dir_array:
            # Skip invalid directories
            if not os.path.isdir(directory):
                print(f"\033[1mSkipping invalid directory:\033[0m {directory}")
                continue
            # Rename valid directories
            print(f"Renaming {directory}...")
            for root, dirs, files in os.walk(directory):
                for file in files:
                    #Skip previously renamed files
                    if renamed_image.match(file):
                        continue

                    base_name, ext = os.path.splitext(file)
                    ext = ext[1:]

                    new_name = f"poster.{ext}"
                    old_file_path = os.path.join(root, file)
                    new_file_path = os.path.join(root, new_name)

                    #Rename File
                    print(f"Renaming {old_file_path} to {new_file_path}...")
                    os.rename(old_file_path, new_file_path)


def main():
    #Script Arguments
    parser = argparse.ArgumentParser(
        description='Rename all TPDB image files to match Plex Local Media Asset formats',
        formatter_class=argparse.RawTextHelpFormatter
    )
    parser.add_argument('-t', '--tv', nargs='+', help='TV Directories to rename', required=False)
    parser.add_argument('-f', '--film', nargs='+', help='Film Directories to rename', required=False)
    parser.epilog = 'Example Usage:\n tpdb-rename.py -t /dir/1/ /dir/2/ -f /dir/1/ /dir/2/'

    args = parser.parse_args()

    #Display help with no arguments provided
    if not any(vars(args).values()):
        parser.print_help()
        return

    if args.tv:
        tv_dirs = TvDirs(args.tv)
        tv_dirs.rename_dir_array()

    if args.film:
        film_dirs = FilmDirs(args.film)
        film_dirs.rename_dir_array()


if __name__ == '__main__':
    main()
