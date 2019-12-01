local grafana = import 'grafonnet/grafana.libsonnet';
local graphPanel = grafana.graphPanel;
local cw = grafana.cloudwatch;
local aws_region = 'eu-west-1';
local period = '1m';

/*
  Instance mapping contains properties of ec2-instance.
    @ var_name -> variable name suffix to be displayed in grafana (e.g.: ec2_id_{var_name})
    @ aws_ec2_name_tag -> Tag:Name value of the instance (one can check it in AWS console).
*/
local instance_group_mapping = [
   {group_name:'load-controller',var_name_ec2_id:'load_controller',aws_ec2_name_tag:'ec2-d-load-controller-plab',group_lead: true},
   {group_name:'load-generators',var_name_ec2_id:'load_generator_1',aws_ec2_name_tag:'ec2-d-load-generator-1-plab',group_lead: true},
   {group_name:'load-generators',var_name_ec2_id:'load_generator_2',aws_ec2_name_tag:'ec2-d-load-generator-2-plab',group_lead: false},
   {group_name:'load-generators',var_name_ec2_id:'load_generator_3',aws_ec2_name_tag:'ec2-d-load-generator-3-plab',group_lead: false},
   {group_name:'load-generators',var_name_ec2_id:'load_generator_4',aws_ec2_name_tag:'ec2-d-load-generator-4-plab',group_lead: false},
   {group_name:'load-generators',var_name_ec2_id:'load_generator_5',aws_ec2_name_tag:'ec2-d-load-generator-5-plab',group_lead: false}
];

local cw_target = {
  attributes(alias,metric,namespace='AWS/EC2',dimensions)::
  cw.target(
    alias=alias,
    region=aws_region,
    namespace=namespace,
    metric=metric,
    dimensions=dimensions,
    period=period
  )
};

//Custom function for adding CPUUtilization panels
local cpu_panel = {
  attributes(panel_name, var_name_ec2_id, alias='{{metric}}')::
  graphPanel.new(
    title='CPU %s' % panel_name,
    datasource='$datasource',
    format='percent',
    nullPointMode='connected',
    min=0,
    max=100,
    decimals=0,
    legend_values=true,
    legend_alignAsTable=true,
    legend_hideEmpty=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    aliasColors={'CPUUtilization':'blue'},
  )
  .addTargets(
    [cw_target.attributes(
      metric='CPUUtilization',
      dimensions={'InstanceId': 'ec2_id_%s' % var_name_ec2_id},
      alias=alias
      )
    ]
  ) + {fillGradient: '7', gridPos: {h:11, w:8}},
};



//Resulting array which is imported to dashboard.jsonnet
{
  panels: 
  [cpu_panel.attributes(panel_name=group.aws_ec2_name_tag,var_name_ec2_id=group.var_name_ec2_id) for group in instance_group_mapping if group.group_lead]
}