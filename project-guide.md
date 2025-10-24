DevOps 프로젝트로 Riderwin.com 블로그 독자를 위한 Flarum 커뮤니티 사이트를 OCI Always Free Tier에 배포하는 GitHub 저장소 이름을 정할 때, 프로젝트의 DevOps 특성(Terraform, Ansible, Docker, GitHub Actions)과 목적을 반영하는 이름을 추천합니다. **추천 이름: `riderwin-devops-oci`**

### 이유:

- **명확성**: `riderwin`은 브랜드, `devops`는 Terraform/Ansible/GitHub Actions 기반 CI/CD를 강조, `oci`는 Oracle Cloud Infrastructure를 나타냄.
- **DevOps 강조**: DevOps 프로젝트로 포지셔닝하며, 인프라 자동화와 배포 파이프라인을 명확히 표현.
- **직관성**: 프로젝트의 기술 스택과 환경을 한눈에 이해 가능.

### 대안 이름:

- `riderwin-community-devops`: 커뮤니티 포럼과 DevOps를 모두 강조.
- `oci-flarum-devops`: Flarum과 OCI 중심, DevOps 워크플로우 반영.
- `riderwin-infra`: 인프라 중심의 간결한 이름.

### 저장소 생성:

- GitHub에서: New Repository > Name: `riderwin-devops-oci` > Public/Private 선택 > Initialize with README.
- 로컬에서: `git clone https://github.com/yourusername/riderwin-devops-oci.git`.

### 초기 README 제안:

```markdown
# Riderwin DevOps OCI

A DevOps project to deploy a Flarum community forum (`community.riderwin.com`) for Riderwin.com's motorcycle community on OCI Always Free Tier using Terraform, Ansible, Docker, and GitHub Actions.

## Overview

- **Goal**: Host a lightweight forum (100-200 daily users) for motorcycle enthusiasts.
- **Tech Stack**: Terraform (OCI infra), Ansible (Docker setup), Docker (Flarum/MySQL), GitHub Actions (CI/CD).
- **Platform**: OCI Always Free Tier (VM.Standard.A1.Flex, 2 OCPU, 12GB RAM).

## Setup

1. Configure OCI credentials (Tenancy/User OCID, API Key).
2. Run Terraform: `terraform apply -var-file=terraform.tfvars`.
3. Deploy with Ansible: `ansible-playbook -i inventory.ini playbook.yml`.
4. Access: `http://<Public_IP>` for Flarum setup.

## Customization

- Categories: Riding Tips, Gear Reviews, Events.
- Extensions: SEO, Image Upload.
```
