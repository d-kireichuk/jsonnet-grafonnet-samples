/*
  Instance mapping contains properties of grouped ec2-instances.
    @ var_name_ec2_id -> variable name suffix to be displayed in grafana (e.g.: ec2_id_{var_name_ec2_id})
    @ instance_name -> Tag:Name value of the instance (one can check it in AWS console).
*/
{
  instance_group_mapping: [
    {group_name:'load-controller',var_name_ec2_id:'load_controller',instance_name:'ec2-d-load-controller-plab',group_lead: true},
    {group_name:'load-generators',var_name_ec2_id:'load_generator_1',instance_name:'ec2-d-load-generator-1-plab',group_lead: true},
    {group_name:'load-generators',var_name_ec2_id:'load_generator_2',instance_name:'ec2-d-load-generator-2-plab',group_lead: false},
    {group_name:'load-generators',var_name_ec2_id:'load_generator_3',instance_name:'ec2-d-load-generator-3-plab',group_lead: false},
    {group_name:'load-generators',var_name_ec2_id:'load_generator_4',instance_name:'ec2-d-load-generator-4-plab',group_lead: false},
    {group_name:'load-generators',var_name_ec2_id:'load_generator_5',instance_name:'ec2-d-load-generator-5-plab',group_lead: false},
  ]
}