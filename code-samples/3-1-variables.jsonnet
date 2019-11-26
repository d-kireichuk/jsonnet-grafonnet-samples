local grafana = import 'grafonnet/grafana.libsonnet';
local var = grafana.template;
local aws_region = 'eu-west-1';

//Custom [static] variables
local var_datasource = var.datasource(name='datasource',query='cloudwatch',current='');

//Query [dynamic] variables
local var_load_controller = 
  var.new(
    name='ec2_id_load_controller',
    datasource='$datasource',
    query='ec2_instance_attribute(%s,InstanceId,{"tag:Name": ["ec2-d-load-controller-plab"]})' % aws_region, //A placeholder for aws_region.
    hide=hide,
    refresh='load'
  );

//Resulting array which is imported to dashboard.jsonnet
{
  vars: [
    var_datasource,
    var_load_controller
  ]
}
