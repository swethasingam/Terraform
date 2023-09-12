# Define a random string resource.
resource "random_string" "random_suffix" {
  length  = 6      # Length of the random string to generate.
  special = false  # Exclude special characters from the random string.
  upper   = false  # Exclude uppercase letters from the random string.
}

# This resource generates a random string of specified length with the specified character set.