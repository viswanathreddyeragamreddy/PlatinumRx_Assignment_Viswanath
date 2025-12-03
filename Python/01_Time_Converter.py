# Program 1: Convert minutes to human readable form using a function

def convert_minutes(total_minutes):
    hours = total_minutes // 60
    mins = total_minutes % 60

    hr_label = "hr" if hours == 1 else "hrs"
    min_label = "minute" if mins == 1 else "minutes"

    return f"{hours} {hr_label} {mins} {min_label}"


minutes = int(input("Enter number of minutes: "))
print(convert_minutes(minutes))
