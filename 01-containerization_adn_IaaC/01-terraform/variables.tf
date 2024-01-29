variable "project" {
  description = "Project"
  default     = "elaborate-tube-412620"
}


variable "region" {
  description = "Region"
  default     = "southamerica-west1"
}


variable "location" {
  description = "Project Location"
  default     = "US"
}


variable "bq_dataset_name" {
  description = "My BigQuery Dataset Name"
  default     = "demo_dataset"
}

variable "gcs_bucket_name" {
  description = "My Storage Bucket Name"
  default     = "elaborate-tube-412620-terra-bucket"
}

variable "gcs_storage_class" {
  description = "Bucket Storage Class"
  default     = "STANDARD"
}