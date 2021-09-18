using System;
using System.Collections.Generic;
using System.Text;
using Confluent.Kafka;

using ScriptEngine.Machine;
using ScriptEngine.Machine.Contexts;

namespace OKafkaEco
{
    [ContextClass("ИсточникKafka","ProducerKafka")]
    public class OKafkaProducer : AutoContext<OKafkaProducer>
    {
        private IProducer<Null, string> producerAsync;
        private ProducerConfig configuration = new ProducerConfig();
        private string currentTopic = null;
        
        public long CurrentTopicOffset = 0;
        
        public OKafkaProducer(string bootstrapServers)
        {
           configuration.BootstrapServers = bootstrapServers;
        }

        /// <summary>
        /// Список разделенных запятыми, с указанием серверов подключения в формате <DNSИмя>:<ПортПодключения>
        /// Значение по умолчанию: "localhost:9094"
        /// </summary>
        [ContextProperty("СписокСерверовСтрокой", "ServersStringList")]
        public string ServersStringList
        {
            get { return (string) configuration.BootstrapServers; }
            set { configuration.BootstrapServers = value; }
        }

        [ContextMethod("ПодключитьПотокОтправки", "StartProduce")]
        public void StartProduce(string topic)
        {
            producerAsync = 
                new ProducerBuilder<Null, string>(configuration).Build();
            currentTopic = topic;
        }
        
        [ContextMethod("Отправить", "Produce")]
        public void Produce(string Message)
        {
            ProduceMessage(Message);
        }

        private DeliveryResult<Null, string> ProduceMessage(string messageString)
        {
            var result = 
                producerAsync.ProduceAsync(
                    currentTopic,
                    new Message<Null, string> { Value = messageString }
                ).Result;
            
            producerAsync.Flush(TimeSpan.FromSeconds(10));

            return result;
        }
    }
}