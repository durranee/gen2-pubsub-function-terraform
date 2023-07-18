## bucket where function source will be uploaded
resource "google_storage_bucket" "source-bucket" {
  name        = "${var.function-name}-source-bucket"
  location    = var.gcp-region
  project     = var.gcp-project
}

## zipping the function code
data "archive_file" "source-archive" {
  type        = "zip"
  source_dir  = "${path.module}/../../src"
  output_path = "${var.function-name}.zip"
}

## uploading the zipped code to the gcp bucket
resource "google_storage_bucket_object" "source-archive-bucket-object" {
  name         = "${var.function-name}-${data.archive_file.source-archive.output_md5}.zip"
  source       = data.archive_file.source-archive.output_path
  bucket       = google_storage_bucket.source-bucket.name
  content_type = "application/zip"
  depends_on = [
    data.archive_file.source-archive,
    google_storage_bucket.source-bucket
  ]
}