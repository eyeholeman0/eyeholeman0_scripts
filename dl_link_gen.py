base_link = input("base_link_($ instead of number): ")
count = int(input("part_count: "))
place_holder = int(input("place_holder: "))
print("-----------------------------------------------------------")
for i in range(1, count + 1):
    s = str(i)
    if(place_holder == 2 and i < 10):
        s = '0' + s
    print(base_link.replace(place_holder*'$', s))