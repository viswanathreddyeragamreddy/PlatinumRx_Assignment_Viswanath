# Program 2: Remove duplicate characters using a loop inside a function

def remove_duplicates(s):
    unique = ""
    for ch in s:
        if ch not in unique:
            unique += ch
    return unique


string_input = input("Enter a string: ")
print(remove_duplicates(string_input))
