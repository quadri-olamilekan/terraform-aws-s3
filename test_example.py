import os
import tftest
import pytest


tfvars = ["./example.tfvars"]


@pytest.fixture(params=tfvars)
def plan(request, directory="./examples", module_name="complete"):
    tfvars_file = request.param
    tf = tftest.TerraformTest(module_name, directory)
    tf.setup()
    plan = tf.plan(
        output=True, use_cache=True, tf_var_file=tfvars_file
    ) 
    return plan

def test_variables(plan):
    tf_vars = plan.variables
    assert "backend_region" in tf_vars
    assert "source_region" in tf_vars
    assert "bucket_name" in tf_vars

def test_outputs(plan):
    assert "destination_bucket" in plan.outputs
    assert "source_bucket" in plan.outputs
    assert "sqs_queue_destination_url" in plan.outputs
    assert "sqs_queue_source_url" in plan.outputs
