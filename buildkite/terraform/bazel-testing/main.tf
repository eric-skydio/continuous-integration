terraform {
  backend "gcs" {
    bucket  = "bazel-buildkite-tf-state"
    prefix  = "bazel-testing"
  }

  required_providers {
    buildkite = {
      source = "buildkite/buildkite"
      version = "0.5.0"
    }
  }
}

provider "buildkite" {
  # can also be set from env: BUILDKITE_API_TOKEN
  #api_token = ""
  organization = "bazel-testing"
}

resource "buildkite_pipeline" "android-testing" {
  name = "Android Testing"
  repository = "https://github.com/googlesamples/android-testing.git"
  steps = templatefile("pipeline.yml.tpl", { envs = {}, steps = { commands = ["curl -sS \"https://raw.githubusercontent.com/bazelbuild/continuous-integration/testing/buildkite/bazelci.py?$(date +%s)\" -o bazelci.py", "python3.6 bazelci.py project_pipeline --file_config=bazelci/buildkite-pipeline.yml | buildkite-agent pipeline upload"] } })
}

resource "buildkite_pipeline" "apple-support-darwin" {
  name = "apple_support :darwin:"
  repository = "https://github.com/bazelbuild/apple_support.git"
  steps = templatefile("pipeline.yml.tpl", { envs = {}, steps = { commands = ["curl -sS \"https://raw.githubusercontent.com/bazelbuild/continuous-integration/testing/buildkite/bazelci.py?$(date +%s)\" -o bazelci.py", "python3.6 bazelci.py project_pipeline | buildkite-agent pipeline upload"] } })
}

resource "buildkite_pipeline" "bazel-bazel" {
  name = "Bazel :bazel:"
  repository = "https://github.com/bazelbuild/bazel.git"
  steps = templatefile("pipeline.yml.tpl", { envs = {}, steps = { commands = ["curl -sS \"https://raw.githubusercontent.com/bazelbuild/continuous-integration/testing/buildkite/bazelci.py?$(date +%s)\" -o bazelci.py", "python3.6 bazelci.py project_pipeline --file_config=.bazelci/postsubmit.yml | buildkite-agent pipeline upload"] } })
}

resource "buildkite_pipeline" "bazel-bazel-github-presubmit" {
  name = "Bazel :bazel: Github Presubmit"
  repository = "https://github.com/bazelbuild/bazel.git"
  steps = templatefile("pipeline.yml.tpl", { envs = {}, steps = { commands = ["curl -sS \"https://raw.githubusercontent.com/bazelbuild/continuous-integration/testing/buildkite/bazelci.py?$(date +%s)\" -o bazelci.py", "python3.6 bazelci.py project_pipeline --file_config=.bazelci/presubmit.yml | buildkite-agent pipeline upload"] } })
}

resource "buildkite_pipeline" "bazel-at-head-plus-disabled" {
  name = "Bazel@HEAD + Disabled"
  repository = "https://github.com/bazelbuild/bazel.git"
  steps = templatefile("pipeline.yml.tpl", { envs = {}, steps = { commands = ["curl -sS \"https://raw.githubusercontent.com/bazelbuild/continuous-integration/testing/buildkite/bazelci.py?$(date +%s)\" -o bazelci.py", "python3.6 bazelci.py bazel_downstream_pipeline --http_config=https://raw.githubusercontent.com/bazelbuild/bazel/master/.bazelci/presubmit.yml --test_disabled_projects | buildkite-agent pipeline upload"] } })
}

resource "buildkite_pipeline" "upb" {
  name = "upb"
  repository = "https://github.com/protocolbuffers/upb.git"
  steps = templatefile("pipeline.yml.tpl", { envs = {}, steps = { commands = ["curl -sS \"https://raw.githubusercontent.com/bazelbuild/continuous-integration/testing/buildkite/bazelci.py?$(date +%s)\" -o bazelci.py", "python3.6 bazelci.py project_pipeline | buildkite-agent pipeline upload"] } })
}
