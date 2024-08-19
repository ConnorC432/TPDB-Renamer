import argparse
import os
import re


#Invalid file extensions
invalid_file_extensions = {'mp4', 'mkv', 'avi', 'mov', 'wmv', 'flv', 'webm', 'srt'}

#TV Directory Class
class TvDirs:
    def __init__(self, tv_dirs_array):
        self.dir_array = tv_dirs_array

    def rename_dir_array(self):
        #Previously renamed file regex
        renamed_image = re.compile(r'(season-specials-poster|show|Season.*|.*S.*E.*)\.(png|jpg|jpeg)$')

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

                    #Get File Extension
                    base_name, ext = os.path.splitext(file)
                    ext = ext[1:]
                    ext = ext.lower()

                    if ext in invalid_file_extensions:
                        continue

                    #Season image file regex
                    season_pattern = re.compile(r'(.*?) - Season ([0-9]+)\.(png|jpg|jpeg)')

                    #Specials image file regex
                    specials_pattern = re.compile(r'(.*?) - Specials\.(png|jpg|jpeg)')

                    #Rename Season Images
                    if season_pattern.match(file):
                        match = season_pattern.match(file)
                        new_name = f"Season {match.group(2)}.{match.group(3)}"

                    #Rename Specials Image
                    elif specials_pattern.match(file):
                        match = specials_pattern.match(file)
                        new_name = f"season-specials-poster.{match.group(2)}"

                    #Rename Show Image
                    else:
                        new_name = f"show.{ext}"

                    if new_name:
                        old_file_path = os.path.join(root, file)
                        new_file_path = os.path.join(root, new_name)

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

                    #Get File Extension
                    base_name, ext = os.path.splitext(file)
                    ext = ext[1:]
                    ext = ext.lower()

                    if ext in invalid_file_extensions:
                        continue

                    #Rename Film Image
                    new_name = f"poster.{ext}"
                    old_file_path = os.path.join(root, file)
                    new_file_path = os.path.join(root, new_name)

                    print(f"Renaming {old_file_path} to {new_file_path}...")
                    os.rename(old_file_path, new_file_path)


def main():
    #Script Arguments Parser
    parser = argparse.ArgumentParser(
        description='Rename all TPDB image files to match Plex Local Media Asset formats',
        formatter_class=argparse.RawTextHelpFormatter
    )
    parser.add_argument('-t', '--tv', nargs='+', help='Specify the root TV Directory(s) to rename', required=False)
    parser.add_argument('-f', '--film', nargs='+', help='Specify the root Film Directory(s) to rename', required=False)
    parser.epilog = 'example usage:\n tpdb-rename.py -t /tv/dir1/ /tv/dir2/ -f /film/dir1/ /film/dir2/'

    args = parser.parse_args()

    #Display help with no arguments provided
    if not any(vars(args).values()):
        parser.print_help()
        return

    #Rename TV Dir Array
    if args.tv:
        tv_dirs = TvDirs(args.tv)
        tv_dirs.rename_dir_array()

    #Rename Film Dir Array
    if args.film:
        film_dirs = FilmDirs(args.film)
        film_dirs.rename_dir_array()


if __name__ == '__main__':
    main()
