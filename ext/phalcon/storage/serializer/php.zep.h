
extern zend_class_entry *phalcon_storage_serializer_php_ce;

ZEPHIR_INIT_CLASS(Phalcon_Storage_Serializer_Php);

PHP_METHOD(Phalcon_Storage_Serializer_Php, serialize);
PHP_METHOD(Phalcon_Storage_Serializer_Php, unserialize);
PHP_METHOD(Phalcon_Storage_Serializer_Php, phpUnserialize);

ZEND_BEGIN_ARG_WITH_RETURN_TYPE_INFO_EX(arginfo_phalcon_storage_serializer_php_serialize, 0, 0, IS_STRING, 0)
ZEND_END_ARG_INFO()

ZEND_BEGIN_ARG_WITH_RETURN_TYPE_INFO_EX(arginfo_phalcon_storage_serializer_php_unserialize, 0, 1, IS_VOID, 0)

	ZEND_ARG_INFO(0, data)
ZEND_END_ARG_INFO()

ZEND_BEGIN_ARG_WITH_RETURN_TYPE_INFO_EX(arginfo_phalcon_storage_serializer_php_phpunserialize, 0, 1, IS_MIXED, 0)
	ZEND_ARG_TYPE_INFO(0, data, IS_STRING, 0)
ZEND_ARG_TYPE_INFO_WITH_DEFAULT_VALUE(0, options, IS_ARRAY, 0, "[]")
ZEND_END_ARG_INFO()

ZEPHIR_INIT_FUNCS(phalcon_storage_serializer_php_method_entry) {
	PHP_ME(Phalcon_Storage_Serializer_Php, serialize, arginfo_phalcon_storage_serializer_php_serialize, ZEND_ACC_PUBLIC)
	PHP_ME(Phalcon_Storage_Serializer_Php, unserialize, arginfo_phalcon_storage_serializer_php_unserialize, ZEND_ACC_PUBLIC)
	PHP_ME(Phalcon_Storage_Serializer_Php, phpUnserialize, arginfo_phalcon_storage_serializer_php_phpunserialize, ZEND_ACC_PRIVATE)
	PHP_FE_END
};
