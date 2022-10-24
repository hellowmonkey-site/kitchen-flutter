const isProd = bool.fromEnvironment('dart.vm.product');

const appTitle = '沃德厨房';
const appId = 1;
const baseUrl =
    isProd ? 'https://kitchen.api.hellowmonkey.cc/' : 'http://127.0.0.1:7001/';
const successCode = 200;
const loginError = 1000;
