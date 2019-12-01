local grafana = import 'grafonnet/grafana.libsonnet';
local mapping = import '4-instance-mapping.jsonnet';
local instance_group_mapping = mapping.instance_group_mapping;
local var = grafana.template;
local aws_region = 'eu-west-1';

//Custom [static] variables
local var_datasource = var.datasource(name='datasource',query='cloudwatch',current='');

//Custom function for adding instanceId query [dynamic] variables
local var_ec2_id = {
  attributes(var_name_ec2_id,instance_name)::
  var.new(
    name='ec2_id_%s' % var_name_ec2_id,
    datasource='$datasource',
    query='ec2_instance_attribute(%s,InstanceId,{"tag:Name":["%s"]})' % [aws_region, instance_name],
    hide='2',
    refresh='load',
  )
};

//Resulting array which is imported to dashboard.jsonnet
{
  vars: [var_datasource] +
  [var_ec2_id.attributes(var_name_ec2_id=instance.var_name_ec2_id,instance_name=instance.instance_name) for instance in instance_group_mapping]
}