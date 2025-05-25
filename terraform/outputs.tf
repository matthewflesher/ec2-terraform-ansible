output "master_public_ip" {
  value = aws_instance.k8s_master.public_ip
}

output "master_public_dns" {
  value = aws_instance.k8s_master.public_dns
}

output "worker_1_public_ip" {
  value = aws_instance.k8s_worker_1.public_ip
}

output "worker_2_public_ip" {
  value = aws_instance.k8s_worker_2.public_ip
}

output "master_private_ip" {
  value = aws_instance.k8s_master.private_ip
}

output "worker_1_private_ip" {
  value = aws_instance.k8s_worker_1.private_ip
}

output "worker_2_private_ip" {
  value = aws_instance.k8s_worker_2.private_ip
}
