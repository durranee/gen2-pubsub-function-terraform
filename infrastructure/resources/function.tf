resource "google_cloudfunctions2_function" "cloud-function" {
  name = var.function-name
  location = var.gcp-region
  project = var.gcp-project

  build_config {
    runtime     = "python310"
    entry_point = "subscribe"
    source {
      storage_source {
        bucket = google_storage_bucket.source-bucket.name
        object = google_storage_bucket_object.source-archive-bucket-object.name
      }
    }
  }

  service_config {
    available_memory                = "256M"
    ingress_settings                = "ALLOW_INTERNAL_ONLY"
    all_traffic_on_latest_revision  = true
  }

  event_trigger {
    trigger_region = var.gcp-region
    event_type     = "google.cloud.pubsub.topic.v1.messagePublished"
    pubsub_topic   = google_pubsub_topic.function-topic.id
    retry_policy   = "RETRY_POLICY_RETRY"

  }

  depends_on = [
    google_storage_bucket.source-bucket,
    data.archive_file.source-archive,
    google_pubsub_topic.function-topic
  ]
}