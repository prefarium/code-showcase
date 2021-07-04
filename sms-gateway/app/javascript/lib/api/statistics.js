import axios from "axios";

const BASE_URL = '/api/v1/admin/statistics';

export const balances   = params => axios.get(`${ BASE_URL }/balances`, { params: params });
export const charts     = params => axios.get(`${ BASE_URL }/charts`, { params: params });
export const info       = ()     => axios.get(`${ BASE_URL }/info`);
export const line_chart = params => axios.get(`${ BASE_URL }/line_chart`, {params: params});
