if [ ! -d "output" ]; then
  mkdir output
fi

#prompt for num_files
read -p "Enter number of files to create: " num_files

# Define an array of file extensions
file_extensions=(".md" ".js" ".txt" ".py" ".java")

# Loop through the number of files to create
for ((i=1; i<=num_files; i++)); do
  # Generate a random file name
  file_name=$(LC_ALL=C < /dev/urandom tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1)

  # Select a random file extension
  file_ext=${file_extensions[$RANDOM % ${#file_extensions[@]}]}
  file_name="$file_name$file_ext"

  # Create the file in the output folder
  touch "output/$file_name"

  # Generate a random file size between 10 bytes and 2MB (2097152 bytes)
  file_size=$((RANDOM % 2097152 + 10))

  # Write random bytes to the file
  dd if=/dev/urandom of="output/$file_name" bs=1 count=$file_size
done