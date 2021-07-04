import axios from "axios";

const BASE_URL = '/api/v1/admin/admins'
let token      = document.getElementsByName('csrf-token')[0].getAttribute('content')

axios.defaults.headers.common['X-CSRF-Token'] = token

export const index  = ()     => { return axios.get(BASE_URL) };
export const create = params => { return axios.post(`${ BASE_URL }/create`, params) };
