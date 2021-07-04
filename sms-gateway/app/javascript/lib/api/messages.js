import axios from "axios";

const BASE_URL = '/api/v1/admin/messages'
let token      = document.getElementsByName('csrf-token')[0].getAttribute('content')

axios.defaults.headers.common['X-CSRF-Token'] = token

export const index  = params => axios.get(BASE_URL, { params });
export const create = params => axios.post(`${ BASE_URL }/create`, params)
