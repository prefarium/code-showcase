import axios from "axios";

const BASE_URL = '/api/v1/admin/users'
let token      = document.getElementsByName('csrf-token')[0].getAttribute('content')

axios.defaults.headers.common['X-CSRF-Token'] = token

export const names  = ()     => { return axios.get(`${ BASE_URL }/names`) };
export const index  = params => { return axios.get(BASE_URL, { params }) };
export const create = params => { return axios.post(`${ BASE_URL }/create`, params) };
