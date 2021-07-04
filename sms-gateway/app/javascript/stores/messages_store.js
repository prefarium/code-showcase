
export default {
  state: {
    statuses: [
      { value: 'with_server_error', name: 'Ошибка' },
      { value: 'preparing',         name: 'В очереди' },
      { value: 'in_progress',       name: 'Отправлено' },
      { value: 'successful',        name: 'Доставлено' },
      { value: 'unsuccessful',      name: 'Не доставлено' },
    ],

    statusesTranslator: {
      undefined: 'Неизвестный ответ от провайдера',
      error:     'Ошибка на стороне провайдера',
      created:   'В очереди на отправку',
      queued:    'В очереди на отправку',
      left:      'Отправлено',
      sent:      'Отправлено',
      delivered: 'Доставлено',
      failed:    'Не доставлено',
      expired:   'Невозможно доставить',
      rejected:  'Отклонено',
      unknown:   'Неизвестно',
    }
  },
};
