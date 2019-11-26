local grafana = import 'grafonnet/grafana.libsonnet';
local var = grafana.template;
local aws_region = 'eu-west-1';

//Custom [static] variables
local var_datasource = var.datasource(name='datasource',query='cloudwatch',current='');

//Custom function for adding instanceId query [dynamic] variables
local var_ec2_id = {
  attributes(var_name,aws_ec2_name_tag)::
  variable.new(
    name='ec2_id_%s' % var_name,
    datasource='$datasource',
    query='ec2_instance_attribute(%s,InstanceId,{"tag:Name":["%s"]})' % [region, aws_ec2_name_tag],
    hide='2',
    refresh='load',
  )
};

//Resulting array which is imported to dashboard.jsonnet
{
  vars: [
    var_datasource,
    var_ec2_id.attributes(var_name='ec2_id_load_controller',aws_ec2_name_tag='ec2-d-load-controller-plab'),
    var_ec2_id.attributes(var_name='ec2_id_load_generator_1',aws_ec2_name_tag='ec2-d-load-generator-1-plab'),
    var_ec2_id.attributes(var_name='ec2_id_load_generator_2',aws_ec2_name_tag='ec2-d-load-generator-2-plab'),
    var_ec2_id.attributes(var_name='ec2_id_load_generator_3',aws_ec2_name_tag='ec2-d-load-generator-3-plab'),
    var_ec2_id.attributes(var_name='ec2_id_load_generator_4',aws_ec2_name_tag='ec2-d-load-generator-4-plab'),
    var_ec2_id.attributes(var_name='ec2_id_load_generator_5',aws_ec2_name_tag='ec2-d-load-generator-5-plab')
  ]
}