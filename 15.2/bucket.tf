resource "yandex_storage_bucket" "my-bucket" {
  access_key = yandex_iam_service_account_static_access_key.sa-netology-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-netology-static-key.secret_key
  bucket = "netology.jkkoaqsqcfpkmswl"
  acl    = "public-read" 
}

resource "yandex_storage_object" "ya-logo" {
  access_key = yandex_iam_service_account_static_access_key.sa-netology-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-netology-static-key.secret_key
  bucket = yandex_storage_bucket.my-bucket.bucket
  key    = "ya-logo.png"
  source = "img/15.2-1.png"
}