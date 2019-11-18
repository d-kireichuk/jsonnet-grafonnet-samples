local grafana = import 'grafonnet/grafana.libsonnet';
local var = grafana.template;

local var_datasource = var.datasource(
  name='datasource',
  query='cloudwatch',
  current='',
  #hide='',
  #label=null,
  #regex='',
  #refresh='load',
);

{
  vars: [var_datasource]
}
