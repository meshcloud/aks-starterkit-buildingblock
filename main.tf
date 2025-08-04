resource "meshstack_project" "dev" {
  metadata = {
    name               = "${var.name}-dev"
    owned_by_workspace = var.workspace_identifier
  }
  spec = {
    display_name = "${var.name}-dev"
    tags         = var.tags != null ? var.tags : {}
  }
}

resource "meshstack_project" "prod" {
  metadata = {
    name               = "${var.name}-prod"
    owned_by_workspace = var.workspace_identifier
  }
  spec = {
    display_name = "${var.name}-prod"
    tags         = var.tags != null ? var.tags : {}
  }
}

resource "meshstack_tenant_v4" "dev" {
  metadata = {
    owned_by_workspace = var.workspace_identifier
    owned_by_project   = meshstack_project.dev.metadata.name
  }

  spec = {
    platform_identifier     = var.full_platform_identifier
    landing_zone_identifier = var.landing_zone_dev_identifier
  }
}

resource "meshstack_tenant_v4" "prod" {
  metadata = {
    owned_by_workspace = var.workspace_identifier
    owned_by_project   = meshstack_project.prod.metadata.name
  }

  spec = {
    platform_identifier     = var.full_platform_identifier
    landing_zone_identifier = var.landing_zone_prod_identifier
  }
}

resource "meshstack_building_block_v2" "repo" {
  spec = {
    building_block_definition_version_ref = {
      uuid = var.github_repo_definition_version_uuid
    }

    display_name = "GitHub Repo ${var.name}"
    target_ref = {
      kind       = "meshWorkspace"
      identifier = var.workspace_identifier
    }

    inputs = {
      repo_name = {
        value_string = var.name
      }
      use_template = {
        value_bool = true
      }
      template_owner = {
        value_string = "likvid-bank"
      }
      template_repo = {
        value_string = "aks-starterkit-template"
      }
    }
  }
}

# takes a while until github repo and aks namespace are ready
resource "time_sleep" "wait_45_seconds" {
  depends_on = [meshstack_building_block_v2.repo]

  create_duration = "45s"
}


resource "meshstack_building_block_v2" "github_actions_dev" {
  depends_on = [meshstack_building_block_v2.repo, time_sleep.wait_45_seconds]

  spec = {
    building_block_definition_version_ref = {
      uuid = var.github_actions_connector_definition_version_uuid
    }
    display_name = "GitHub Actions Connector Dev"
    target_ref = {
      kind = "meshTenant"
      uuid = meshstack_tenant_v4.dev.metadata.uuid
    }
    parent_building_blocks = [{
      buildingblock_uuid = meshstack_building_block_v2.repo.metadata.uuid
      definition_uuid    = var.github_repo_definition_uuid
    }]
  }
}

resource "meshstack_building_block_v2" "github_actions_prod" {
  depends_on = [meshstack_building_block_v2.repo, meshstack_building_block_v2.github_actions_dev]

  spec = {
    building_block_definition_version_ref = {
      uuid = var.github_actions_connector_definition_version_uuid
    }
    display_name = "GitHub Actions Connector Prod"
    target_ref = {
      kind = "meshTenant"
      uuid = meshstack_tenant_v4.prod.metadata.uuid
    }
    parent_building_blocks = [{
      buildingblock_uuid = meshstack_building_block_v2.repo.metadata.uuid
      definition_uuid    = var.github_repo_definition_uuid
    }]
  }
}
