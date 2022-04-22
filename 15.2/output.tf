output "link-to-image" {
  value = "https://storage.yandexcloud.net/${yandex_storage_bucket.my-bucket.bucket}/${yandex_storage_object.ya-logo.key}"
}
