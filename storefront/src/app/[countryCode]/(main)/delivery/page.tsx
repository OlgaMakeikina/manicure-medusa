"use client"

import styles from './page.module.css'

export default function DeliveryPaymentPage() {
  return (
    <div className={styles.container}>
      <div className={styles.header}>
        <h1>Доставка и оплата</h1>
        <p>Условия доставки материалов и способы оплаты</p>
      </div>

      <div className={styles.content}>
        <div className={styles.deliverySection}>
          <h2 className={styles.sectionTitle}>Доставка</h2>
          
          <div className={styles.contactGroup}>
            <h3>Для клиентов</h3>
            <div className={styles.contactItem}>
              <p className={styles.highlight}>Минимальный заказ: 100 единиц лака</p>
            </div>
            <div className={styles.contactItem}>
              <p>По Москве и МО — от 800₽</p>
            </div>
            <div className={styles.contactItem}>
              <p>Срок доставки: 2-3 дня</p>
            </div>
            <span className={styles.badge}>Бесплатная доставка от 5000₽</span>
          </div>

          <div className={styles.contactGroup}>
            <h3>Для мастеров</h3>
            <div className={styles.contactItem}>
              <p className={styles.highlight}>Заказ от 1 единицы</p>
            </div>
            <div className={styles.contactItem}>
              <p>По Москве и МО — от 500₽</p>
            </div>
            <div className={styles.contactItem}>
              <p>Срок доставки: 1-2 дня</p>
            </div>
            <span className={styles.badge}>Бесплатная доставка от 3000₽</span>
          </div>

          <div className={styles.contactGroup}>
            <h3>Дополнительные опции</h3>
            <div className={styles.contactItem}>
              <p>Экспресс-доставка — от 1500₽ (в течение дня)</p>
            </div>
            <div className={styles.contactItem}>
              <p>Самовывоз — скидка 10%</p>
            </div>
            <div className={styles.contactItem}>
              <p>По России — от 1200₽ (5-10 дней)</p>
            </div>
          </div>
        </div>

        <div className={styles.paymentSection}>
          <h2 className={styles.sectionTitle}>Оплата</h2>
          
          <div className={styles.contactGroup}>
            <h3>Способы оплаты</h3>
            <div className={styles.paymentMethods}>
              <div className={styles.paymentMethod}>Банковская карта</div>
              <div className={styles.paymentMethod}>СБП</div>
              <div className={styles.paymentMethod}>Наличные</div>
              <div className={styles.paymentMethod}>Баланс сайта</div>
            </div>
          </div>

          <div className={styles.subscriptionGroup}>
            <h3>Профессиональная подписка</h3>
            <div className={styles.subscriptionPrice}>990₽</div>
            <div className={styles.contactItem}>
              <p>в месяц для мастеров</p>
            </div>
            <div className={styles.subscriptionFeatures}>
              <div className={styles.feature}>• Специальные цены в кабинете</div>
              <div className={styles.feature}>• Заказы без минимальной партии</div>
              <div className={styles.feature}>• Приоритетная доставка</div>
              <div className={styles.feature}>• Обучающие материалы</div>
              <div className={styles.feature}>• Аналитика и отчеты</div>
            </div>
          </div>

          <div className={styles.contactGroup}>
            <h3>Безопасность</h3>
            <div className={styles.contactItem}>
              <p>Все платежи защищены SSL-шифрованием</p>
            </div>
            <div className={styles.contactItem}>
              <p>Данные карт не сохраняются на серверах</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}