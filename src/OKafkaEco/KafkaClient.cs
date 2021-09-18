using Confluent.Kafka;
using ScriptEngine.Machine.Contexts;

namespace OKafkaEco
{
    //Примеры https://github.com/confluentinc/confluent-kafka-dotnet
    //параметры (понадобятся и в 1С) https://github.com/edenhill/librdkafka/blob/master/CONFIGURATION.md
    
    [ContextClass("КафкаКлиент","KafkaClient")]
    public class KafkaClient : AutoContext<KafkaClient>
    {
        public KafkaClient()
        {
            //Это вот грузить librdkafka
            Library.Load();
        }
        [ContextProperty("Версия", "Version")]
        public string LibVersion
        {
            get { return "0.5.1-webinar"; }
        }

        [ContextMethod("СоздатьИсточник", "CreateProducer")]
        public OKafkaProducer CreateProducer(string bootstrapServers)
        {
            var producerWrapper = new OKafkaProducer(bootstrapServers);
            
            return producerWrapper;
        }
        
        [ContextMethod("СоздатьПодписчика", "CreateConsumer")]
        public OKafkaConsumer CreateConsumer(string bootstrapServers)
        {
            return new OKafkaConsumer(bootstrapServers);
            
        }
        
        /// <summary>
        /// Конструктор по умолчанию
        /// </summary>
        /// <returns>Клиент сервера Kafka</returns>
        [ScriptConstructor]
        public static KafkaClient Constructor()
        {
            return new KafkaClient();
        }
    }
}