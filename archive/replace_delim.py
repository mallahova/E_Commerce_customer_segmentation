# This code changes the delimter used in a csv file that will later be used in BULK INSERT statement
import csv


def replace_delimiter(input_file, output_file):
    with open(input_file, "r", newline="") as csvfile:
        with open(output_file, "w", newline="") as outfile:
            reader = csv.reader(csvfile)
            writer = csv.writer(outfile, delimiter="}")  # Set the new delimiter here
            for row in reader:
                writer.writerow(row)


# Example usage:
input_file = (
    "basics/projects/Ecommerce_database/archive/olist_order_reviews_dataset.csv"
)
output_file = "output.csv"
replace_delimiter(input_file, output_file)
