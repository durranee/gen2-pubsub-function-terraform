data "external" "trigger-info" {
  program = ["bash", "${path.module}/../scripts/get_trigger_info.sh"]

  query = {
    function_name = google_cloudfunctions2_function.cloud-function.name
    region = var.gcp-region
    dl_topic = google_pubsub_topic.deadletter-topic.name
  }
  depends_on = [
    google_cloudfunctions2_function.cloud-function,
    google_pubsub_topic.deadletter-topic
  ]
}

