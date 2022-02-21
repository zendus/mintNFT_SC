a_file = open("anime.txt", "r")

list_of_lists = []
for line in a_file:
#   stripped_line = line.strip()
#   line_list = stripped_line.split()
  list_of_lists.append(str(line.strip()))

a_file.close()

print(list_of_lists)