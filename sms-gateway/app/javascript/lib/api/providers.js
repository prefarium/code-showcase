import axios from "axios";

const BASE_URL = '/api/v1/admin/providers'

export const balance = params => { return axios.get(`${ BASE_URL }/balance`, params) };
export const names   = ()     => { return axios.get(`${ BASE_URL }/names`) };
export const index   = params => { return axios.get(BASE_URL, params) };
