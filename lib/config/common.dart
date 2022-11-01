const isProd = bool.fromEnvironment('dart.vm.product');

const appTitle = '沃德厨房';
const appId = 1;
const baseUrl = isProd
    ? 'https://kitchen.api.hellowmonkey.cc/'
    : 'http://192.168.1.77:7001/';
const appUrl = '${baseUrl}common/app-info?download';
const successCode = 200;
const loginError = 10000;
const webUrl = 'https://kitchen.hellowmonkey.cc/';
