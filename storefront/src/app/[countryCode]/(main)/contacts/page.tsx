"use client"

import styles from './page.module.css'

export default function ContactsPage() {
  const handlePhoneClick = (e: React.MouseEvent<HTMLAnchorElement>) => {
    if (!navigator.userAgent.match(/Mobile|iP(hone|od)|Android|BlackBerry|IEMobile/)) {
      e.preventDefault()
      const phone = e.currentTarget.textContent
      if (phone) {
        navigator.clipboard.writeText(phone)
        const originalText = e.currentTarget.textContent
        e.currentTarget.textContent = 'Скопировано'
        setTimeout(() => {
          if (originalText) e.currentTarget.textContent = originalText
        }, 1500)
      }
    }
  }

  return (
    <div className={styles.container}>
      <div className={styles.header}>
        <h1>Контакты</h1>
        <p>Свяжитесь с нами удобным способом</p>
      </div>

      <div className={styles.content}>
        <div className={styles.contactSection}>
          <div className={styles.contactGroup}>
            <h3>Телефон</h3>
            <div className={styles.contactItem}>
              <a href="tel:+79991234567" onClick={handlePhoneClick}>
                +7 (999) 123-45-67
              </a>
            </div>
            <div className={styles.messengers}>
              <a 
                href="https://wa.me/79991234567" 
                className={styles.messengerBtn} 
                title="WhatsApp"
              >
                <span>W</span>
              </a>
              <a 
                href="https://t.me/yourusername" 
                className={styles.messengerBtn} 
                title="Telegram"
              >
                <span>T</span>
              </a>
              <a 
                href="viber://chat?number=79991234567" 
                className={styles.messengerBtn} 
                title="Viber"
              >
                <span>V</span>
              </a>
            </div>
          </div>

          <div className={styles.contactGroup}>
            <h3>Email</h3>
            <div className={styles.contactItem}>
              <a href="mailto:hello@manicure-studio.ru">hello@manicure-studio.ru</a>
            </div>
          </div>

          <div className={styles.contactGroup}>
            <h3>Адрес</h3>
            <div className={styles.contactItem}>
              <p>г. Москва, ул. Примерная, 123</p>
            </div>
            <div className={styles.contactItem}>
              <p>ТЦ "Красота", 2 этаж</p>
            </div>
          </div>

          <div className={styles.contactGroup}>
            <h3>Социальные сети</h3>
            <div className={styles.contactItem}>
              <a href="https://instagram.com/manicure_studio" target="_blank" rel="noopener noreferrer">
                Instagram
              </a>
            </div>
            <div className={styles.contactItem}>
              <a href="https://vk.com/manicure_studio" target="_blank" rel="noopener noreferrer">
                ВКонтакте
              </a>
            </div>
          </div>
        </div>

        <div className={styles.mapContainer}>
          <div className={styles.mapPlaceholder}>
            <div className={styles.mapIcon}>
              <span>📍</span>
            </div>
            <h4>Карта местоположения</h4>
            <p>Будет добавлена после<br />определения адреса</p>
          </div>
        </div>
      </div>

      <div className={styles.workingHours}>
        <h3>Режим работы</h3>
        <div className={styles.hoursGrid}>
          <div className={styles.dayHours}>
            <strong>Понедельник — Пятница</strong>
            <span>09:00 — 21:00</span>
          </div>
          <div className={styles.dayHours}>
            <strong>Суббота — Воскресенье</strong>
            <span>10:00 — 20:00</span>
          </div>
        </div>
      </div>
    </div>
  )
}