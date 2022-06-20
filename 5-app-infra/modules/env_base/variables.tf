/**
 * Copyright 2021 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

variable "environment" {
  description = "The environment the single project belongs to"
  type        = string
}

variable "vpc_type" {
  description = "The type of VPC to attach the project to. Possible options are base or restricted."
  type        = string
}

variable "region" {
  description = "The GCP region to create and test resources in"
  type        = string
  default     = "us-central1"
}

variable "service_account" {
  default = null
  type    = object({
    email  = string,
    scopes = set(string)
  })
  description = "Service account to attach to the instance. See https://www.terraform.io/docs/providers/google/r/compute_instance_template.html#service_account."
}

variable "folder_id" {
  description = "The folder id where project will be created"
  type        = string
}

variable "business_code" {
  description = "The code that describes which business unit owns the project"
  type        = string
  default     = "abcd"
}

variable "project_suffix" {
  description = "The name of the GCP project. Max 16 characters with 3 character business unit code."
  type        = string
}

variable "cr_sa_roles" {
  description = "Roles to grant to the Cloud Run Service account"
  type        = list(any)
  default     = []
}

variable "secrets_project_id" {
  description = "Name of the project to access secrets from"
  type        = string
}
