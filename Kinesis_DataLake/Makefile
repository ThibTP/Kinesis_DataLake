.PHONY: init plan apply destroy test setup teardown generate_data

# Terraform commands
init:
    @echo "Initializing Terraform..."
    @terraform init

plan: init
    @echo "Creating Terraform plan..."
    @terraform plan

apply: init
    @echo "Applying Terraform changes..."
    @terraform apply -auto-approve

destroy:
    @echo "Destroying Terraform-managed infrastructure..."
    @terraform destroy -auto-approve

# Python commands
test:
    @echo "Running unit tests..."
    @python -m unittest discover tests

# Environment setup and teardown
setup: apply
    @echo "Environment setup complete."

teardown: destroy
    @echo "Environment teardown complete."

# Generate data structures
generate_data:
    @echo "Generating data structures..."
    @python create_data_structures.py
