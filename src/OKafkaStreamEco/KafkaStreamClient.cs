using ScriptEngine.Machine.Contexts;

namespace OKafkaStreamEco
{
    
    [ContextClass("КлиентКафкаПотоков","KafkaStreamClient")]
    public class KafkaStreamClient : AutoContext<KafkaStreamClient>
    {
        public KafkaStreamClient()
        {
            
        }

        /// <summary>
        /// Конструктор по умолчанию
        /// </summary>
        /// <returns>Клиент сервера Kafka</returns>
        [ScriptConstructor]
        public static KafkaStreamClient Constructor()
        {
            return new KafkaStreamClient();
        }
    }
}