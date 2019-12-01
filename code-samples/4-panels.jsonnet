local grafana = import 'grafonnet/grafana.libsonnet';
local graphPanel = grafana.graphPanel;
local cw = grafana.cloudwatch;
local aws_region = 'eu-west-1';
local period = '1m';

local instance_group_mapping = [
   {group_name:'load-controller',var_name_ec2_id:'load_controller',instance_name:'ec2-d-load-controller-plab',group_lead: true},
   {group_name:'load-generators',var_name_ec2_id:'load_generator_1',instance_name:'ec2-d-load-generator-1-plab',group_lead: true},
   {group_name:'load-generators',var_name_ec2_id:'load_generator_2',instance_name:'ec2-d-load-generator-2-plab',group_lead: false},
   {group_name:'load-generators',var_name_ec2_id:'load_generator_3',instance_name:'ec2-d-load-generator-3-plab',group_lead: false},
   {group_name:'load-generators',var_name_ec2_id:'load_generator_4',instance_name:'ec2-d-load-generator-4-plab',group_lead: false},
   {group_name:'load-generators',var_name_ec2_id:'load_generator_5',instance_name:'ec2-d-load-generator-5-plab',group_lead: false}
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
  attributes(group)::
  graphPanel.new(
    title='CPU %s' % group,
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
  )
  .addTargets(
    [cw_target.attributes(
      metric='CPUUtilization',
      dimensions={'InstanceId': '$ec2_id_%s' % instance.var_name_ec2_id},
      alias=instance.instance_name
      ) for instance in instance_group_mapping if instance.group_name == group
    ]
  ) + {fillGradient: '7', gridPos: {h:11, w:8}},
};

//Custom function for adding Networking panels
local network_panel = {
  attributes(instance)::
  graphPanel.new(
    title='Network %s' % instance,
    datasource='$datasource',
    format='bytes',
    nullPointMode='connected',
    decimals=1,
    legend_values=true,
    legend_alignAsTable=true,
    legend_hideEmpty=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    aliasColors={
      'NetworkIn': 'rgb(45, 93, 135)',
      'NetworkOut': 'semi-dark-red',
    }  
  )
  .addSeriesOverride({'alias': '/.*Out.*/', 'transform': 'negative-Y'})
  .addTargets(
    [cw_target.attributes(metric='NetworkIn',dimensions={'InstanceId': '$ec2_id_%s' % ec2_instance.var_name_ec2_id},
      alias='{{metric}}') for ec2_instance in instance_group_mapping if ec2_instance.instance_name == instance
    ] +
    [cw_target.attributes(metric='NetworkOut',dimensions={'InstanceId': '$ec2_id_%s' % ec2_instance.var_name_ec2_id},
      alias='{{metric}}') for ec2_instance in instance_group_mapping if ec2_instance.instance_name == instance
    ],
  ) + {fillGradient: '7', gridPos: {h:11, w:8, x:8}},
};

//Custom function for adding DiskOps panels
local disk_panel = {
  attributes(instance)::
  graphPanel.new(
    title='Disk Ops %s' % instance,
    datasource='$datasource',
    format='short',
    nullPointMode='connected',
    decimals=1,
    lines=false,
    bars=true,
    legend_values=true,
    legend_alignAsTable=true,
    legend_hideEmpty=true,
    legend_min=true,
    legend_max=true,
    legend_avg=true,
    aliasColors={
      'NetworkIn': 'rgb(45, 93, 135)',
      'NetworkOut': 'semi-dark-red',
    }  
  )
  .addSeriesOverride({'alias': '/.*Read.*/', 'transform': 'negative-Y'})
  .addTargets(
    [cw_target.attributes(metric='EBSWriteOps',dimensions={'InstanceId': '$ec2_id_%s' % ec2_instance.var_name_ec2_id},
      alias='{{metric}}') for ec2_instance in instance_group_mapping if ec2_instance.instance_name == instance
    ] +
    [cw_target.attributes(metric='EBSReadOps',dimensions={'InstanceId': '$ec2_id_%s' % ec2_instance.var_name_ec2_id},
      alias='{{metric}}') for ec2_instance in instance_group_mapping if ec2_instance.instance_name == instance
    ],
  ) + {gridPos: {h:11, w:8, x:16}},
};

//Resulting array containing panels object which is imported to dashboard.jsonnet
{
  panels: 
  [cpu_panel.attributes(group=group.group_name) for group in instance_group_mapping if group.group_lead] +
  [network_panel.attributes(instance=instance.instance_name) for instance in instance_group_mapping] +
  [disk_panel.attributes(instance=instance.instance_name) for instance in instance_group_mapping]
}