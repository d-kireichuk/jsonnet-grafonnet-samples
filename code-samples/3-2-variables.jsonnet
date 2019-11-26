local grafana = import 'grafonnet/grafana.libsonnet';
local var = grafana.template;
local aws_region = 'eu-west-1';

//Custom [static] variables
local var_datasource = var.datasource(name='datasource',query='cloudwatch',current='');

//Query [dynamic] variables
local var_ec2_id_load_controller = 
  variable.new(
    name='ec2_id_load_controller',
    datasource='$datasource',
    query='ec2_instance_attribute(%s,InstanceId,{"tag:Name": ["ec2-d-load-controller-plab"]})' % aws_region,
    hide=hide,
    refresh='load'
  )

local var_ec2_id_load_generator_1 = 
  variable.new(
    name='ec2_id_load_generator_1',
    datasource='$datasource',
    query='ec2_instance_attribute(%s,InstanceId,{"tag:Name": ["ec2-d-load-generator-1-plab"]})' % aws_region,
    hide=hide,
    refresh='load'
  )

local var_ec2_id_load_generator_2 = 
  variable.new(
    name='ec2_id_load_generator_2',
    datasource='$datasource',
    query='ec2_instance_attribute(%s,InstanceId,{"tag:Name": ["ec2-d-load-generator-2-plab"]})' % aws_region,
    hide=hide,
    refresh='load'
  )

local var_ec2_id_load_generator_3 = 
  variable.new(
    name='ec2_id_load_generator_3',
    datasource='$datasource',
    query='ec2_instance_attribute(%s,InstanceId,{"tag:Name": ["ec2-d-load-generator-3-plab"]})' % aws_region,
    hide=hide,
    refresh='load'
  )

local var_ec2_id_load_generator_4 = 
  variable.new(
    name='ec2_id_load_generator_4',
    datasource='$datasource',
    query='ec2_instance_attribute(%s,InstanceId,{"tag:Name": ["ec2-d-load-generator-4-plab"]})' % aws_region,
    hide=hide,
    refresh='load'
  )

local var_ec2_id_load_generator_5 = 
  variable.new(
    name='ec2_id_load_generator_5',
    datasource='$datasource',
    query='ec2_instance_attribute(%s,InstanceId,{"tag:Name": ["ec2-d-load-generator-5-plab"]})' % aws_region,
    hide=hide,
    refresh='load'
  )

//Resulting array which is imported to dashboard.jsonnet
{
  vars: [
    var_datasource,
    var_ec2_id_load_controller,
    var_ec2_id_load_generator_1,
    var_ec2_id_load_generator_2,
    var_ec2_id_load_generator_3,
    var_ec2_id_load_generator_4,
    var_ec2_id_load_generator_5
  ]
}
