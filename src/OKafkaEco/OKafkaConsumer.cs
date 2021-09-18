using ScriptEngine.Machine;
using ScriptEngine.Machine.Contexts;

using ScriptEngine.HostedScript.Library;

using System;
using System.Linq;

using System.Collections.Generic;

using System.Threading;
using Confluent.Kafka;

using ScriptEngine.Machine.Values;

namespace OKafkaEco
{
    [ContextClass("ПодписчикКафка","ConsumerKafka")]
    public class OKafkaConsumer : AutoContext<OKafkaConsumer>
    {
        private IConsumer<Ignore, string> consumerAsync;
        private ConsumerConfig configuration = new ConsumerConfig();
        private bool NewMessages = true;
        private IValue latestOffset = ValueFactory.Create();
        private int assignetOffset = 0;
        private string currentTopic = "";

        [ContextProperty("СписокСерверовСтрокой", "ServersStringList")]
        public string ServersStringList
        {
            get { return (string) configuration.BootstrapServers; }
            set { configuration.BootstrapServers = value; }
        }

        [ContextProperty("ЕстьЕщеСообщения", "HasNewMessages")]
        public bool HasNewMessages
        {
            get { return NewMessages; }
        }

        [ContextProperty("ТекущееСмещение", "CurrentOffset")]
        public IValue CurrentOffset
        {
            get { return latestOffset; }
        }
       
        public OKafkaConsumer(string bootstrapServers)
        {
            configuration.BootstrapServers = bootstrapServers;
            configuration.EnableAutoCommit = false;
            configuration.AutoOffsetReset = AutoOffsetReset.Earliest;
            configuration.EnablePartitionEof = true;
        }

        [ContextMethod("Подписаться", "Subcribe")]
        public void SubcribeForTopic(string groupID, string topic)
        {
            configuration.GroupId = groupID;
            consumerAsync = 
                new ConsumerBuilder<Ignore, string>(configuration)
                .SetErrorHandler((_, e) => Console.WriteLine($"Error: {e.Reason}"))
                .SetStatisticsHandler((_, json) => Console.WriteLine($"Statistics: {json}"))
                .SetPartitionsAssignedHandler((c, partitions) =>
                {
                    Console.WriteLine($"Assigned partitions: [{string.Join(", ", partitions)}]");
                    return partitions.Select(tp => new TopicPartitionOffset(tp, assignetOffset));
                })
                .SetPartitionsRevokedHandler((c, partitions) =>
                {
                    Console.WriteLine($"Revoking assignment: [{string.Join(", ", partitions)}]");
                })
                .Build();
            consumerAsync.Subscribe(topic);
            currentTopic = topic;
        }

        [ContextMethod("Назначить", "Assign")]
        public void SubcribeForTopic(int offset)
        {
            assignetOffset = offset;
        }

        [ContextMethod("Подтвердить", "Commit")]
        public void CommitPartition(MapImpl offset)
        {
            var consumer = consumerAsync;

            var topicFix = offset.Retrieve(
                ValueFactory.Create("Канал")).AsString();
            var partFix = (int) offset.Retrieve(
                ValueFactory.Create("Раздел")).AsNumber();
            var offsetFix = (int) offset.Retrieve(
                ValueFactory.Create("Смещение")).AsNumber();

            TopicPartitionOffset[] topicsCommit = 
                {
                    new TopicPartitionOffset(
                        topicFix,
                        partFix,
                        offsetFix
                    )
                };

            var commiterList = new List<TopicPartitionOffset>();
            consumer.Commit(
                new List<TopicPartitionOffset>(topicsCommit)
            ); 
        }


        [ContextMethod("ПолучитьСообщение", "ConsumeMessage")]
        public IValue Consume(int WaitTime = 1000)
        {
            var consumer = consumerAsync;
                   
                while (true)
                    {
                     try
                        {
                            var consumeResult = consumer.Consume(WaitTime);
                            if (consumeResult!=null)
                            {
                                if (consumeResult.IsPartitionEOF)
                                {
                                    Console.WriteLine($"Reached end of topic {consumeResult.Topic}, partition {consumeResult.Partition}, offset {consumeResult.Offset}.");
                                    return ValueFactory.Create();
                                }
                                
                                var obj = new MapImpl();
                                
                                latestOffset = obj;

                                obj.Insert(
                                    ValueFactory.Create("Канал"), ValueFactory.Create(
                                        consumeResult.TopicPartitionOffset.Topic
                                    )
                                );

                                obj.Insert(
                                    ValueFactory.Create("Раздел"), ValueFactory.Create(
                                        consumeResult.TopicPartitionOffset.Partition
                                    )
                                );

                                obj.Insert(
                                    ValueFactory.Create("Смещение"), ValueFactory.Create(
                                        consumeResult.TopicPartitionOffset.Offset
                                    )
                                );

                                return ValueFactory.Create(consumeResult.Message.Value);
                            }
                        } catch (ConsumeException e)
                        {
                            throw new Exception(
                                $"Error occured: {e.Error.Reason}"
                            );
                        }
                    }
              
            
        }

    }
}