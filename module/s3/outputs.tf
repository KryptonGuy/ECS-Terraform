output "codepipelinebucket_id" {
  value = aws_s3_bucket.codepipelinebucket.id
}


output "software_bucket_id" {
  value = aws_s3_bucket.software_bucket.id
}

output "public_bucket_id" {
  value = aws_s3_bucket.public_bucket.id
}