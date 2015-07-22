# encoding: UTF-8
require 'parslet'
require 'pp'

#REVISAR el asunto de la inserción automática de puntoycomas del capítulo 7 sección 7.9.1. Done.

class MiniEcma < Parslet::Parser

    root(:program)
    rule(:space)                                            { match("[\s\t]").repeat(1) }
    rule(:space?)                                           { space.maybe }
    rule(:blank)                                            { (space | lineTerminator).repeat(1) }
    rule(:blank?)                                            { blank.maybe }
    rule(:decimalDigit)                                     { match("[0-9]") }
    rule(:decimalDigits)                                    { match("[0-9]").repeat(1) }
    rule(:nonZeroDigit)                                     { match("[1-9]") }
    rule(:octalDigit)                                       { match("[0-7]") }
    rule(:hexDigit)                                         { match("[0-9a-fA-F]") }
    rule(:unicodeIdentifierStart)                           { match("[\u02c1\u02c6-\u02d1\u02e0-\u02e4\u02ec\u02ee\u0370-\u0374\u0376\u0377\u037a-\u037d\u0386\u0388-\u038a\u038c\u038e-\u03a1\u03a3-\u03f5\u03f7-\u0481\u048a-\u0527\u0531-\u0556\u0559\u0561-\u0587\u05d0-\u05ea\u05f0-\u05f2\u0620-\u064a\u066e\u066f\u0671-\u06d3\u06d5\u06e5\u06e6\u06ee\u06ef\u06fa-\u06fc\u06ff\u0710\u0712-\u072f\u074d-\u07a5\u07b1\u07ca-\u07ea\u07f4\u07f5\u07fa\u0800-\u0815\u081a\u0824\u0828\u0840-\u0858\u08a0\u08a2-\u08ac\u0904-\u0939\u093d\u0950\u0958-\u0961\u0971-\u0977\u0979-\u097f\u0985-\u098c\u098f\u0990\u0993-\u09a8\u09aa-\u09b0\u09b2\u09b6-\u09b9\u09bd\u09ce\u09dc\u09dd\u09df-\u09e1\u09f0\u09f1\u0a05-\u0a0a\u0a0f\u0a10\u0a13-\u0a28\u0a2a-\u0a30\u0a32\u0a33\u0a35\u0a36\u0a38\u0a39\u0a59-\u0a5c\u0a5e\u0a72-\u0a74\u0a85-\u0a8d\u0a8f-\u0a91\u0a93-\u0aa8\u0aaa-\u0ab0\u0ab2\u0ab3\u0ab5-\u0ab9\u0abd\u0ad0\u0ae0\u0ae1\u0b05-\u0b0c\u0b0f\u0b10\u0b13-\u0b28\u0b2a-\u0b30\u0b32\u0b33\u0b35-\u0b39\u0b3d\u0b5c\u0b5d\u0b5f-\u0b61\u0b71\u0b83\u0b85-\u0b8a\u0b8e-\u0b90\u0b92-\u0b95\u0b99\u0b9a\u0b9c\u0b9e\u0b9f\u0ba3\u0ba4\u0ba8-\u0baa\u0bae-\u0bb9\u0bd0\u0c05-\u0c0c\u0c0e-\u0c10\u0c12-\u0c28\u0c2a-\u0c33\u0c35-\u0c39\u0c3d\u0c58\u0c59\u0c60\u0c61\u0c85-\u0c8c\u0c8e-\u0c90\u0c92-\u0ca8\u0caa-\u0cb3\u0cb5-\u0cb9\u0cbd\u0cde\u0ce0\u0ce1\u0cf1\u0cf2\u0d05-\u0d0c\u0d0e-\u0d10\u0d12-\u0d3a\u0d3d\u0d4e\u0d60\u0d61\u0d7a-\u0d7f\u0d85-\u0d96\u0d9a-\u0db1\u0db3-\u0dbb\u0dbd\u0dc0-\u0dc6\u0e01-\u0e30\u0e32\u0e33\u0e40-\u0e46\u0e81\u0e82\u0e84\u0e87\u0e88\u0e8a\u0e8d\u0e94-\u0e97\u0e99-\u0e9f\u0ea1-\u0ea3\u0ea5\u0ea7\u0eaa\u0eab\u0ead-\u0eb0\u0eb2\u0eb3\u0ebd\u0ec0-\u0ec4\u0ec6\u0edc-\u0edf\u0f00\u0f40-\u0f47\u0f49-\u0f6c\u0f88-\u0f8c\u1000-\u102a\u103f\u1050-\u1055\u105a-\u105d\u1061\u1065\u1066\u106e-\u1070\u1075-\u1081\u108e\u10a0-\u10c5\u10c7\u10cd\u10d0-\u10fa\u10fc-\u1248\u124a-\u124d\u1250-\u1256\u1258\u125a-\u125d\u1260-\u1288\u128a-\u128d\u1290-\u12b0\u12b2-\u12b5\u12b8-\u12be\u12c0\u12c2-\u12c5\u12c8-\u12d6\u12d8-\u1310\u1312-\u1315\u1318-\u135a\u1380-\u138f\u13a0-\u13f4\u1401-\u166c\u166f-\u167f\u1681-\u169a\u16a0-\u16ea\u16ee-\u16f0\u1700-\u170c\u170e-\u1711\u1720-\u1731\u1740-\u1751\u1760-\u176c\u176e-\u1770\u1780-\u17b3\u17d7\u17dc\u1820-\u1877\u1880-\u18a8\u18aa\u18b0-\u18f5\u1900-\u191c\u1950-\u196d\u1970-\u1974\u1980-\u19ab\u19c1-\u19c7\u1a00-\u1a16\u1a20-\u1a54\u1aa7\u1b05-\u1b33\u1b45-\u1b4b\u1b83-\u1ba0\u1bae\u1baf\u1bba-\u1be5\u1c00-\u1c23\u1c4d-\u1c4f\u1c5a-\u1c7d\u1ce9-\u1cec\u1cee-\u1cf1\u1cf5\u1cf6\u1d00-\u1dbf\u1e00-\u1f15\u1f18-\u1f1d\u1f20-\u1f45\u1f48-\u1f4d\u1f50-\u1f57\u1f59\u1f5b\u1f5d\u1f5f-\u1f7d\u1f80-\u1fb4\u1fb6-\u1fbc\u1fbe\u1fc2-\u1fc4\u1fc6-\u1fcc\u1fd0-\u1fd3\u1fd6-\u1fdb\u1fe0-\u1fec\u1ff2-\u1ff4\u1ff6-\u1ffc\u2071\u207f\u2090-\u209c\u2102\u2107\u210a-\u2113\u2115\u2119-\u211d\u2124\u2126\u2128\u212a-\u212d\u212f-\u2139\u213c-\u213f\u2145-\u2149\u214e\u2160-\u2188\u2c00-\u2c2e\u2c30-\u2c5e\u2c60-\u2ce4\u2ceb-\u2cee\u2cf2\u2cf3\u2d00-\u2d25\u2d27\u2d2d\u2d30-\u2d67\u2d6f\u2d80-\u2d96\u2da0-\u2da6\u2da8-\u2dae\u2db0-\u2db6\u2db8-\u2dbe\u2dc0-\u2dc6\u2dc8-\u2dce\u2dd0-\u2dd6\u2dd8-\u2dde\u2e2f\u3005-\u3007\u3021-\u3029\u3031-\u3035\u3038-\u303c\u3041-\u3096\u309d-\u309f\u30a1-\u30fa\u30fc-\u30ff\u3105-\u312d\u3131-\u318e\u31a0-\u31ba\u31f0-\u31ff\u3400-\u4db5\u4e00-\u9fcc\ua000-\ua48c\ua4d0-\ua4fd\ua500-\ua60c\ua610-\ua61f\ua62a\ua62b\ua640-\ua66e\ua67f-\ua697\ua6a0-\ua6ef\ua717-\ua71f\ua722-\ua788\ua78b-\ua78e\ua790-\ua793\ua7a0-\ua7aa\ua7f8-\ua801\ua803-\ua805\ua807-\ua80a\ua80c-\ua822\ua840-\ua873\ua882-\ua8b3\ua8f2-\ua8f7\ua8fb\ua90a-\ua925\ua930-\ua946\ua960-\ua97c\ua984-\ua9b2\ua9cf\uaa00-\uaa28\uaa40-\uaa42\uaa44-\uaa4b\uaa60-\uaa76\uaa7a\uaa80-\uaaaf\uaab1\uaab5\uaab6\uaab9-\uaabd\uaac0\uaac2\uaadb-\uaadd\uaae0-\uaaea\uaaf2-\uaaf4\uab01-\uab06\uab09-\uab0e\uab11-\uab16\uab20-\uab26\uab28-\uab2e\uabc0-\uabe2\uac00-\ud7a3\ud7b0-\ud7c6\ud7cb-\ud7fb\uf900-\ufa6d\ufa70-\ufad9\ufb00-\ufb06\ufb13-\ufb17\ufb1d\ufb1f-\ufb28\ufb2a-\ufb36\ufb38-\ufb3c\ufb3e\ufb40\ufb41\ufb43\ufb44\ufb46-\ufbb1\ufbd3-\ufd3d\ufd50-\ufd8f\ufd92-\ufdc7\ufdf0-\ufdfb\ufe70-\ufe74\ufe76-\ufefc\uff21-\uff3a\uff41-\uff5a\uff66-\uffbe\uffc2-\uffc7\uffca-\uffcf\uffd2-\uffd7\uffda-\uffdc]") }    # REVISAR
    rule(:unicodeIdentifierPart)                            { match("[\u02c1\u02c6-\u02d1\u02e0-\u02e4\u02ec\u02ee\u0370-\u0374\u0376\u0377\u037a-\u037d\u0386\u0388-\u038a\u038c\u038e-\u03a1\u03a3-\u03f5\u03f7-\u0481\u048a-\u0527\u0531-\u0556\u0559\u0561-\u0587\u05d0-\u05ea\u05f0-\u05f2\u0620-\u064a\u066e\u066f\u0671-\u06d3\u06d5\u06e5\u06e6\u06ee\u06ef\u06fa-\u06fc\u06ff\u0710\u0712-\u072f\u074d-\u07a5\u07b1\u07ca-\u07ea\u07f4\u07f5\u07fa\u0800-\u0815\u081a\u0824\u0828\u0840-\u0858\u08a0\u08a2-\u08ac\u0904-\u0939\u093d\u0950\u0958-\u0961\u0971-\u0977\u0979-\u097f\u0985-\u098c\u098f\u0990\u0993-\u09a8\u09aa-\u09b0\u09b2\u09b6-\u09b9\u09bd\u09ce\u09dc\u09dd\u09df-\u09e1\u09f0\u09f1\u0a05-\u0a0a\u0a0f\u0a10\u0a13-\u0a28\u0a2a-\u0a30\u0a32\u0a33\u0a35\u0a36\u0a38\u0a39\u0a59-\u0a5c\u0a5e\u0a72-\u0a74\u0a85-\u0a8d\u0a8f-\u0a91\u0a93-\u0aa8\u0aaa-\u0ab0\u0ab2\u0ab3\u0ab5-\u0ab9\u0abd\u0ad0\u0ae0\u0ae1\u0b05-\u0b0c\u0b0f\u0b10\u0b13-\u0b28\u0b2a-\u0b30\u0b32\u0b33\u0b35-\u0b39\u0b3d\u0b5c\u0b5d\u0b5f-\u0b61\u0b71\u0b83\u0b85-\u0b8a\u0b8e-\u0b90\u0b92-\u0b95\u0b99\u0b9a\u0b9c\u0b9e\u0b9f\u0ba3\u0ba4\u0ba8-\u0baa\u0bae-\u0bb9\u0bd0\u0c05-\u0c0c\u0c0e-\u0c10\u0c12-\u0c28\u0c2a-\u0c33\u0c35-\u0c39\u0c3d\u0c58\u0c59\u0c60\u0c61\u0c85-\u0c8c\u0c8e-\u0c90\u0c92-\u0ca8\u0caa-\u0cb3\u0cb5-\u0cb9\u0cbd\u0cde\u0ce0\u0ce1\u0cf1\u0cf2\u0d05-\u0d0c\u0d0e-\u0d10\u0d12-\u0d3a\u0d3d\u0d4e\u0d60\u0d61\u0d7a-\u0d7f\u0d85-\u0d96\u0d9a-\u0db1\u0db3-\u0dbb\u0dbd\u0dc0-\u0dc6\u0e01-\u0e30\u0e32\u0e33\u0e40-\u0e46\u0e81\u0e82\u0e84\u0e87\u0e88\u0e8a\u0e8d\u0e94-\u0e97\u0e99-\u0e9f\u0ea1-\u0ea3\u0ea5\u0ea7\u0eaa\u0eab\u0ead-\u0eb0\u0eb2\u0eb3\u0ebd\u0ec0-\u0ec4\u0ec6\u0edc-\u0edf\u0f00\u0f40-\u0f47\u0f49-\u0f6c\u0f88-\u0f8c\u1000-\u102a\u103f\u1050-\u1055\u105a-\u105d\u1061\u1065\u1066\u106e-\u1070\u1075-\u1081\u108e\u10a0-\u10c5\u10c7\u10cd\u10d0-\u10fa\u10fc-\u1248\u124a-\u124d\u1250-\u1256\u1258\u125a-\u125d\u1260-\u1288\u128a-\u128d\u1290-\u12b0\u12b2-\u12b5\u12b8-\u12be\u12c0\u12c2-\u12c5\u12c8-\u12d6\u12d8-\u1310\u1312-\u1315\u1318-\u135a\u1380-\u138f\u13a0-\u13f4\u1401-\u166c\u166f-\u167f\u1681-\u169a\u16a0-\u16ea\u16ee-\u16f0\u1700-\u170c\u170e-\u1711\u1720-\u1731\u1740-\u1751\u1760-\u176c\u176e-\u1770\u1780-\u17b3\u17d7\u17dc\u1820-\u1877\u1880-\u18a8\u18aa\u18b0-\u18f5\u1900-\u191c\u1950-\u196d\u1970-\u1974\u1980-\u19ab\u19c1-\u19c7\u1a00-\u1a16\u1a20-\u1a54\u1aa7\u1b05-\u1b33\u1b45-\u1b4b\u1b83-\u1ba0\u1bae\u1baf\u1bba-\u1be5\u1c00-\u1c23\u1c4d-\u1c4f\u1c5a-\u1c7d\u1ce9-\u1cec\u1cee-\u1cf1\u1cf5\u1cf6\u1d00-\u1dbf\u1e00-\u1f15\u1f18-\u1f1d\u1f20-\u1f45\u1f48-\u1f4d\u1f50-\u1f57\u1f59\u1f5b\u1f5d\u1f5f-\u1f7d\u1f80-\u1fb4\u1fb6-\u1fbc\u1fbe\u1fc2-\u1fc4\u1fc6-\u1fcc\u1fd0-\u1fd3\u1fd6-\u1fdb\u1fe0-\u1fec\u1ff2-\u1ff4\u1ff6-\u1ffc\u2071\u207f\u2090-\u209c\u2102\u2107\u210a-\u2113\u2115\u2119-\u211d\u2124\u2126\u2128\u212a-\u212d\u212f-\u2139\u213c-\u213f\u2145-\u2149\u214e\u2160-\u2188\u2c00-\u2c2e\u2c30-\u2c5e\u2c60-\u2ce4\u2ceb-\u2cee\u2cf2\u2cf3\u2d00-\u2d25\u2d27\u2d2d\u2d30-\u2d67\u2d6f\u2d80-\u2d96\u2da0-\u2da6\u2da8-\u2dae\u2db0-\u2db6\u2db8-\u2dbe\u2dc0-\u2dc6\u2dc8-\u2dce\u2dd0-\u2dd6\u2dd8-\u2dde\u2e2f\u3005-\u3007\u3021-\u3029\u3031-\u3035\u3038-\u303c\u3041-\u3096\u309d-\u309f\u30a1-\u30fa\u30fc-\u30ff\u3105-\u312d\u3131-\u318e\u31a0-\u31ba\u31f0-\u31ff\u3400-\u4db5\u4e00-\u9fcc\ua000-\ua48c\ua4d0-\ua4fd\ua500-\ua60c\ua610-\ua61f\ua62a\ua62b\ua640-\ua66e\ua67f-\ua697\ua6a0-\ua6ef\ua717-\ua71f\ua722-\ua788\ua78b-\ua78e\ua790-\ua793\ua7a0-\ua7aa\ua7f8-\ua801\ua803-\ua805\ua807-\ua80a\ua80c-\ua822\ua840-\ua873\ua882-\ua8b3\ua8f2-\ua8f7\ua8fb\ua90a-\ua925\ua930-\ua946\ua960-\ua97c\ua984-\ua9b2\ua9cf\uaa00-\uaa28\uaa40-\uaa42\uaa44-\uaa4b\uaa60-\uaa76\uaa7a\uaa80-\uaaaf\uaab1\uaab5\uaab6\uaab9-\uaabd\uaac0\uaac2\uaadb-\uaadd\uaae0-\uaaea\uaaf2-\uaaf4\uab01-\uab06\uab09-\uab0e\uab11-\uab16\uab20-\uab26\uab28-\uab2e\uabc0-\uabe2\uac00-\ud7a3\ud7b0-\ud7c6\ud7cb-\ud7fb\uf900-\ufa6d\ufa70-\ufad9\ufb00-\ufb06\ufb13-\ufb17\ufb1d\ufb1f-\ufb28\ufb2a-\ufb36\ufb38-\ufb3c\ufb3e\ufb40\ufb41\ufb43\ufb44\ufb46-\ufbb1\ufbd3-\ufd3d\ufd50-\ufd8f\ufd92-\ufdc7\ufdf0-\ufdfb\ufe70-\ufe74\ufe76-\ufefc\uff21-\uff3a\uff41-\uff5a\uff66-\uffbe\uffc2-\uffc7\uffca-\uffcf\uffd2-\uffd7\uffda-\uffdc0-9\u0300-\u036f\u0483-\u0487\u0591-\u05bd\u05bf\u05c1\u05c2\u05c4\u05c5\u05c7\u0610-\u061a\u064b-\u0669\u0670\u06d6-\u06dc\u06df-\u06e4\u06e7\u06e8\u06ea-\u06ed\u06f0-\u06f9\u0711\u0730-\u074a\u07a6-\u07b0\u07c0-\u07c9\u07eb-\u07f3\u0816-\u0819\u081b-\u0823\u0825-\u0827\u0829-\u082d\u0859-\u085b\u08e4-\u08fe\u0900-\u0903\u093a-\u093c\u093e-\u094f\u0951-\u0957\u0962\u0963\u0966-\u096f\u0981-\u0983\u09bc\u09be-\u09c4\u09c7\u09c8\u09cb-\u09cd\u09d7\u09e2\u09e3\u09e6-\u09ef\u0a01-\u0a03\u0a3c\u0a3e-\u0a42\u0a47\u0a48\u0a4b-\u0a4d\u0a51\u0a66-\u0a71\u0a75\u0a81-\u0a83\u0abc\u0abe-\u0ac5\u0ac7-\u0ac9\u0acb-\u0acd\u0ae2\u0ae3\u0ae6-\u0aef\u0b01-\u0b03\u0b3c\u0b3e-\u0b44\u0b47\u0b48\u0b4b-\u0b4d\u0b56\u0b57\u0b62\u0b63\u0b66-\u0b6f\u0b82\u0bbe-\u0bc2\u0bc6-\u0bc8\u0bca-\u0bcd\u0bd7\u0be6-\u0bef\u0c01-\u0c03\u0c3e-\u0c44\u0c46-\u0c48\u0c4a-\u0c4d\u0c55\u0c56\u0c62\u0c63\u0c66-\u0c6f\u0c82\u0c83\u0cbc\u0cbe-\u0cc4\u0cc6-\u0cc8\u0cca-\u0ccd\u0cd5\u0cd6\u0ce2\u0ce3\u0ce6-\u0cef\u0d02\u0d03\u0d3e-\u0d44\u0d46-\u0d48\u0d4a-\u0d4d\u0d57\u0d62\u0d63\u0d66-\u0d6f\u0d82\u0d83\u0dca\u0dcf-\u0dd4\u0dd6\u0dd8-\u0ddf\u0df2\u0df3\u0e31\u0e34-\u0e3a\u0e47-\u0e4e\u0e50-\u0e59\u0eb1\u0eb4-\u0eb9\u0ebb\u0ebc\u0ec8-\u0ecd\u0ed0-\u0ed9\u0f18\u0f19\u0f20-\u0f29\u0f35\u0f37\u0f39\u0f3e\u0f3f\u0f71-\u0f84\u0f86\u0f87\u0f8d-\u0f97\u0f99-\u0fbc\u0fc6\u102b-\u103e\u1040-\u1049\u1056-\u1059\u105e-\u1060\u1062-\u1064\u1067-\u106d\u1071-\u1074\u1082-\u108d\u108f-\u109d\u135d-\u135f\u1712-\u1714\u1732-\u1734\u1752\u1753\u1772\u1773\u17b4-\u17d3\u17dd\u17e0-\u17e9\u180b-\u180d\u1810-\u1819\u18a9\u1920-\u192b\u1930-\u193b\u1946-\u194f\u19b0-\u19c0\u19c8\u19c9\u19d0-\u19d9\u1a17-\u1a1b\u1a55-\u1a5e\u1a60-\u1a7c\u1a7f-\u1a89\u1a90-\u1a99\u1b00-\u1b04\u1b34-\u1b44\u1b50-\u1b59\u1b6b-\u1b73\u1b80-\u1b82\u1ba1-\u1bad\u1bb0-\u1bb9\u1be6-\u1bf3\u1c24-\u1c37\u1c40-\u1c49\u1c50-\u1c59\u1cd0-\u1cd2\u1cd4-\u1ce8\u1ced\u1cf2-\u1cf4\u1dc0-\u1de6\u1dfc-\u1dff\u200c\u200d\u203f\u2040\u2054\u20d0-\u20dc\u20e1\u20e5-\u20f0\u2cef-\u2cf1\u2d7f\u2de0-\u2dff\u302a-\u302f\u3099\u309a\ua620-\ua629\ua66f\ua674-\ua67d\ua69f\ua6f0\ua6f1\ua802\ua806\ua80b\ua823-\ua827\ua880\ua881\ua8b4-\ua8c4\ua8d0-\ua8d9\ua8e0-\ua8f1\ua900-\ua909\ua926-\ua92d\ua947-\ua953\ua980-\ua983\ua9b3-\ua9c0\ua9d0-\ua9d9\uaa29-\uaa36\uaa43\uaa4c\uaa4d\uaa50-\uaa59\uaa7b\uaab0\uaab2-\uaab4\uaab7\uaab8\uaabe\uaabf\uaac1\uaaeb-\uaaef\uaaf5\uaaf6\uabe3-\uabea\uabec\uabed\uabf0-\uabf9\ufb1e\ufe00-\ufe0f\ufe20-\ufe26\ufe33\ufe34\ufe4d-\ufe4f\uff10-\uff19\uff3f]") }    # REVISAR
    
    rule(:identifierStart)                                  { unicodeIdentifierStart | match("[$_a-zA-Z]") | 
                                                            str("\\") >> str("u") >> hexDigit.repeat(4,4) } #
    rule(:identifierPart)                                   { identifierStart | unicodeIdentifierPart | match("[0-9]") }
    rule(:identifier)                                       { domEvent.as(:DOM_EV) | (str("xmlhttprequest") | str("activexobject")).as(:XMLHTTP) | (identifierStart >> identifierPart.repeat(1).maybe) }
    
    rule(:exponentIndicator)                                { match("[eE]") }
    rule(:signedInteger)                                    { match("[+-]").maybe >> match("[0-9]").repeat(1) }
    rule(:decimalIntegerLiteral)                            { str("0") | nonZeroDigit >> decimalDigits.repeat }
    rule(:exponenPart)                                      { exponentIndicator >> signedInteger }
    rule(:octalIntegerLiteral)                              { (str("0") >> octalDigit.repeat(1)) }
    rule(:hexIntegerLiteral)                                { (str("0") >> match("[xX]") >> hexDigit.repeat(1)) }
    rule(:decimalLiteral)                                   { (decimalIntegerLiteral >> str(".") >> decimalDigits.repeat >> exponentPart.maybe) |
                                                            (str(".") >> decimalDigits >> exponentPart.maybe) |
                                                            (decimalIntegerLiteral >> exponentPart.maybe) }
    rule(:lineContinuation)                                 { str("\\") >> ( match("\r\n") | match("\r") | match("\n")) }
    rule(:octalEscapeSequence)                              {  }    # REVISAR (?:[1-7][0-7]{0,2}|[0-7]{2,3}) PÁG 244 ECMA
    rule(:hexEscapeSequence)                                { match("[x]") >> hexDigit.repeat(2,2) }
    rule(:uncodeEscapeSequence)                             { match("[u]") >> hexDigit.repeat(4,4) }
    rule(:singleEscapeCharacter)                            { match("[\'\"\\bfnrtv]")}
    rule(:nonEscapeCharacter)                               { match("[^\'\"\\bfnrtv0-9xu]") }
    rule(:characterEscapeSequence)                          { singleEscapeCharacter | nonEscapeCharacter }
    rule(:escapeSequence)                                   { characterEscapeSequence | octalEscapeSequence | hexEscapeSequence | unicodeEscapeSequence }
    rule(:doubleStringCharacter)                            { match("[^\"\\\n\r]").repeat(1) | 
                                                            ( str("\\") >> escapeSequence ) | lineContinuation }
    rule(:singleStringCharacter)                            { match("[^\'\\\n\r]").repeat(1) | 
                                                            ( str("\\") >> escapeSequence ) | lineContinuation }
    rule(:stringLiteral)                                    { (str("\"") >> doubleStringCharacter.repeat(1).maybe >> str("\"") | 
                                                            str("\'") >> singleStringCharacter.repeat(1).maybe >> str("\'")) }
    rule(:regularExpressionNonTerminator)                   { match(/[^\n\r]/) }
    rule(:regularExpressionBackslashSequence)               { str("\\") >> regularExpressionNonTerminator }
    rule(:regularExpressionClassChar)                       { match(/[^\n\r\]\\]/) | regularExpressionBackslashSequence }
    rule(:regularExpressionClass)                           { str("\[") >> regularExpressionClassChar.repeat >> str("\]") }
    rule(:regularExpressionFlags)                           { identifierPart.repeat }
    rule(:regularExpressionFirstChar)                       { match(/[^\n\r\*\\\/\[]/) | regularExpressionBackslashSequence | regularExpressionClass }
    rule(:regularExpressionChar)                            { match(/[^\n\r\\\/\[]/) | regularExpressionBackslashSequence | regularExpressionClass }
    rule(:regularExpressionBody)                            { regularExpressionFirstChar >> regularExpressionChar.repeat }
    rule(:regularExpressionLiteral)                         { str("/") >> regularExpressionBody >> str("/") >> regularExpressionFlags >> blank?}
    
    
    # REVISAR. Línea 44
    rule(:regexpLiteral)                                    { (str("<REGEXP>") >> regularExpressionLiteral).as(:REGEXP_LITERAL) }
    rule(:brPlus)                                           { (match("\r\n") | match("\n") | match("\n")).repeat(1) >> match("\s").repeat >> str("++") }
    rule(:brMinus)                                          { (match("\r\n") | match("\n") | match("\n")).repeat(1) >> match("\s").repeat >> str("--") }
    rule(:newLine_space)                                    { (match("\s").repeat(1) >> match(/\r|\n/)).as(:SEMICOLON_SPACE) }
    
    # 7.4 Comments
    rule(:comment)                                  { (multiLineComment | singleLineComment).repeat(1) >> blank? }    
    rule(:multiLineComment)                         { str('/*') >> (str('*/').absent? >> any).repeat(1) >> str('*/') }
    rule(:singleLineComment)                        { str('//') >> (match('\n').absent? >> any).repeat(1) >> (lineTerminator | eof) }
    
    # 7.3: Line Terminators
    rule(:lineTerminator)                           { match("[\n\r]").repeat(1) }   # página 28
    rule(:lineTerminator?)                          { lineTerminator.maybe }
    rule(:instanceof)       { str("instanceof") }
    rule(:this)             { str("this") }
    rule(:var)              { str("var") }
    rule(:null)             { str("null") }
    rule(:class)            { str("class") }
    rule(:const)            { str("const") }
    rule(:enum)             { str("enum") }
    rule(:export)           { str("export") }
    rule(:extends)          { str("extends") }
    rule(:import)           { str("import") }
    rule(:super)            { str("super") }
    rule(:semicolon)        { str(";") }
    rule(:comma)            { str(",") }
    rule(:question)         { str("?") }
    rule(:tripleEqual)      { str("===") }
    rule(:doubleEqual)      { str("==") }
    rule(:equal)            { str("=") }
    rule(:strictNotEqual)   { str("!==") }
    rule(:notEqual)         { str("!=").as(:NOT_EQUAL) }
    rule(:comp1)            { str("<<=").as(:COMP1) }
    rule(:comp2)            { str("<=").as(:COMP2) }
    rule(:comp3)            { str("<").as(:COMP3) }
    rule(:comp4)            { str(">>=").as(:COMP4) }
    rule(:comp5)            { str(">=").as(:COMP5) }
    rule(:comp6)            { str(">").as(:COMP6) }
    rule(:assign_plus)      { str("+=").as(:ASSIGN_PLUS) }
    rule(:assign_minus)     { str("-=").as(:ASSIGN_MINUS) }
    rule(:assign_asterisc)  { str("*=").as(:ASSIGN_ASTERISC) }
    rule(:times)            { str("*").as(:TIMES) }
    rule(:assign_slash)     { str("/=").as(:ASSIGN_SLASH) }
    rule(:assign_percent)   { str("%=").as(:ASSIGN_PERCENT) }
    rule(:and_op)           { str("&&").as(:AND_OP) }
    rule(:ampersand)        { str("&").as(:AMPERSAND) }
    rule(:or_op)            { str("||").as(:OR_OP) }
    rule(:assign_bar)       { str("|=").as(:ASSIGN_BAR) }
    rule(:bar)              { str("|").as(:BAR) }
    rule(:assign_angle)     { str("^=").as(:ASSIGN_ANGLE) }
    rule(:angle)            { str("^").as(:ANGLE) }
    rule(:eof)              { any.absent? }
    
    
    # Definición de Producciones Gramaticales
    rule(:statement)                        { comment | block | breakStatement.as(:BREAK_STAT) | continueStatement | debuggerStatement.as(:DEBUGGER_STAT) | ifStatement | iterationStatement.as(:ITER_STAT) | returnStatement | withStatement.as(:WITH_STAT) | switchStatement | throwStatement | tryStatement.as(:TRY_STAT) | expressionStatement | labelledStatement | variableStatement | emptyStatement }
    rule(:block)                            { str("{") >> blank? >> statementList >> blank? >> str("}") >> blank? }
    rule(:statementList)                    { (statement >> blank?).repeat }
    rule(:variableStatement)                { var >> space >> variableDeclarationList >> space? >> ((str(";") | lineTerminator | str("}").present?) >> blank? | eof) }
    rule(:variableDeclarationList)          { variableDeclaration >> blank? >> str(",") >> blank? >> variableDeclarationList | variableDeclaration }
    rule(:variableDeclarationListNoIn)      { variableDeclarationNoIn >> blank? >> str(",") >> blank? >> variableDeclarationListNoIn | variableDeclarationNoIn }
    rule(:variableDeclaration)              { identifier >> blank? >> initializer | identifier }
    rule(:variableDeclarationNoIn)          { identifier >> blank? >> initializerNoIn | identifier }
    rule(:initializer)                      { equal >> blank? >> assignmentExpression }
    rule(:initializerNoIn)                  { equal >> blank? >> assignmentExpressionNoIn }
    rule(:emptyStatement)                   { space? >> (str(";") | lineTerminator) >> blank? }
    rule(:expressionStatement)              { expressionNoBF >> space? >> ((semicolon | lineTerminator | str("}").present?) >> blank? | eof) }
    rule(:ifStatement)                      { str("if") >> space? >> str("(") >> space? >> expression >> space? >> str(")") >> blank? >> comment.repeat(1).maybe >> statement >> blank? >> (str("else") >> blank? >> statement >> blank?).maybe  }
    rule(:iterationStatement)               { str("do") >> blank? >> statement >> space? >> str("while") >> space? >> str("(") >> space? >> expression >> space? >> str(")") >> space? >> ((semicolon | lineTerminator | str("}").present?) >> blank? | eof) |
                                            str("while") >> space? >> str("(") >> space? >> expression >> space? >> str(")") >> blank? >> (statement >> blank?).repeat(1) |
                                            (str("for") >> space? >> str("(") >> space? >> expressionNoIn.as(:EXP_NOIN).maybe >> space? >> semicolon >> space? >> expression.maybe >> space? >> semicolon >> space? >> expression.maybe >> space? >> str(")") >> blank? >> statement.as(:STATEMENT) >> blank?).as(:FOR_STAT) |
                                            str("for") >> space? >> str("(") >> space? >> var >> space >> variableDeclarationListNoIn >> space? >> str(";") >> space? >> expression.maybe >> space? >> str(";") >> space? >> expression.maybe >> space? >> str(")") >> blank? >> statement >> blank? |
                                            str("for") >> space? >> str("(") >> space? >> leftHandSideExpression >> space >> str("in") >> space >> expression >> space? >> str(")") >> blank? >> statement >> blank? |
                                            str("for") >> space? >> str("(") >> space? >> var >> space >> variableDeclarationNoIn >> space >> str("in") >> space >> expression >> space? >> str(")") >> blank? >> statement >> blank? }
    rule(:continueStatement)                { str("continue") >> space? >> (identifier >> space?).maybe >> ((semicolon | lineTerminator | str("}").present?) >> blank? | eof) }
    rule(:breakStatement)                   { str("break") >> space? >> (identifier >> space?).maybe >> ((semicolon | lineTerminator | str("}").present?) >> blank? | eof) }
    rule(:returnStatement)                  { str("return") >> space? >> (expression >> space?).maybe >> ((semicolon | lineTerminator | (blank? >> str("}")).present?) >> blank? | eof) }
    rule(:withStatement)                    { str("with") >> space? >> str("(") >> space? >> expression >> space? >> str(")") >> space? >> statement }
    rule(:switchStatement)                  { str("switch") >> space? >> str("(") >> space? >> expression.as(:EXPRES) >> space? >> str(")") >> blank? >> caseBlock }
    rule(:caseBlock)                        { str("{") >> blank? >> caseClauses >> blank? >>(defaultClause >> blank? >> caseClauses).maybe >> str("}") }
    rule(:caseClauses)                      { caseClause.repeat(1) }
    rule(:caseClause)                       { str("case") >> space >> expression >> space? >> str(":") >> blank? >> statementList }
    rule(:defaultClause)                    { str("default") >> space? >> str(":") >> blank? >> statementList }
    rule(:labelledStatement)                { identifier >> space? >> str(":") >> blank? >> statement }
    rule(:throwStatement)                   { str("throw") >> space >> expression >> space? >> ((str(";") | lineTerminator | str("}").present?) >> blank? | eof)}#| str("throw") >> expression >> error }
    rule(:tryStatement)                     { (str("try") >> space? >> block >> blank?).as(:TRY) >> (catchRule.as(:CATCH)  >> blank? >> finally.as(:FINALLY) | catchRule.as(:CATCH) | finally.as(:FINALLY)) >> blank? }
    rule(:catchRule)                        { str("catch") >> space? >> str("(") >> space? >> identifier >> space? >> str(")") >> space? >> block }
    rule(:finally)                          { str("finally") >> space? >> block }
    rule(:debuggerStatement)                { str("debugger") >> space? >> str(";") >> blank? }
    rule(:functionDeclaration)              { str("function") >> space >> identifier >> str("(") >> space? >> formalParameterList.as(:PARAM_LST).maybe >> space? >> str(")") >> blank? >> str("{") >> blank? >> functionBody >> blank? >> str("}") }
    rule(:functionExpression)               { str("function") >> (space >> identifier >> space?).maybe >> str("(") >> space? >> formalParameterList.maybe >> space? >> str(")") >> blank? >> str("{") >> blank? >> functionBody >> blank? >> str("}") >> blank? }
    rule(:formalParameterList)              { identifier >> (space? >> str(",") >> space? >> identifier).repeat(1).maybe }
    rule(:functionBody)                     { sourceElements.maybe }
    rule(:program)                          { sourceElements.repeat(1) >> eof }
    rule(:sourceElements)                   { sourceElement.repeat(1) }
    rule(:sourceElement)                    { functionDeclaration.as(:FN_DEC) | statement.as(:STAT) } # 
    rule(:primaryExpression)                { primaryExpressionNoBrace | objectLiteral }
    rule(:primaryExpressionNoBrace)         { str("this") | identifier | literal | arrayLiteral.as(:ARR_LIT) | str("(") >> space? >> expression >> space? >> str(")") }
    rule(:arrayLiteral)                     { str("[") >> space? >> str("]") |
                                            str("[") >> space? >> elementList >> space? >> str(",") >> space? >> elision >> space? >> str("]") |
                                            str("[") >> space? >> elementList >> space? >> str(",") >> space? >> str("]") |
                                            str("[") >> space? >> elementList >> space? >> str("]") |
                                            str("[") >> space? >> elision >> space? >> str("]") }
    rule(:elementList)                      { assignmentExpression >> space? >> str(",") >> space? >> elementList |
                                            assignmentExpression | 
                                            elision >> assignmentExpression >> (  space? >> str(",") >> space? >> elementList ).maybe }
    rule(:elision)                          { str(",").repeat(1) }
    rule(:objectLiteral)                    { str("{") >> blank? >> ( propertyNameAndValueList >> space? >> str(",").maybe ).maybe >> blank? >> str("}") }
    rule(:propertyNameAndValueList)         { propertyAssignment >> (blank? >> str(",") >> blank? >> propertyAssignment).repeat(1).maybe }
    rule(:propertyAssignment)               { propertyName >> space? >> str(":") >> space? >> assignmentExpression}
    rule(:propertyName)                     { identifierName | stringLiteral | numericLiteral }
    rule(:propertySetParameterList)         { identifier }
    rule(:newExpression)                    { memberExpression | str("new") >> space >> newExpression }
    rule(:newExpressionNoBF)                { memberExpressionNoBF | (str("new") >> space >> newExpression).as(:NEBF) }
    rule(:callExpression)                   { memberExpression >> arguments >> (arguments | blank?>>str("[") >> space? >> expression >> space? >> str("]") | blank?>>str(".") >> identifierName).repeat(1) |
                                             memberExpression >> arguments }
    rule(:callExpressionNoBF)               { memberExpressionNoBF >> arguments >> (arguments | blank?>> str("[") >> space? >> expression >> space? >> str("]") | blank?>> str(".") >> identifierName).repeat(1) |
                                            memberExpressionNoBF >> arguments }
    rule(:memberExpression)                 { str("new") >> space >> memberExpression >> arguments |
                                              ( functionExpression | primaryExpression) >> (blank? >> str("[") >> space? >> expression >> space? >> str("]") | blank? >> str(".") >> identifierName).repeat(1) | (functionExpression | primaryExpression) }
    rule(:memberExpressionNoBF)             { str("new") >> space >> memberExpression >> arguments |
                                            primaryExpressionNoBrace >> (blank?>> str("[") >> space? >> expression >> space? >> str("]") | blank? >> str(".") >> identifierName).repeat(1) | primaryExpressionNoBrace }
    rule(:identifierName)                   { (reservedWord >> (space.present? | lineTerminator.present?))| identifier }
    rule(:arguments)                        { str("(") >> space? >> argumentList.maybe >> space? >> str(")") }
    rule(:argumentList)                     { assignmentExpression >> space? >> ( str(",") >> space? >> assignmentExpression ).repeat(1).maybe }
    rule(:leftHandSideExpression)           { callExpression | newExpression }
    rule(:leftHandSideExpressionNoBF)       { callExpressionNoBF | newExpressionNoBF }
    rule(:postfixExpression)                { leftHandSideExpression >> str("++") |
                                            leftHandSideExpression >> str("--") |
                                            leftHandSideExpression }
    rule(:postfixExpressionNoBF)            { leftHandSideExpressionNoBF >> str("++") |
                                            leftHandSideExpressionNoBF >> str("--") |
                                            leftHandSideExpressionNoBF }
    rule(:unaryExpression)                  { unaryExpr | postfixExpression }
    rule(:unaryExpressionNoBF)              { unaryExpr | postfixExpressionNoBF }
    rule(:unaryExpr)                        { str("delete") >> space >> unaryExpression |
                                            str("typeof") >> space >> unaryExpression |
                                            str("void") >> space >> unaryExpression |
                                            str("++") >> unaryExpression |
                                            str("--") >> unaryExpression |
                                            str("+") >> unaryExpression |
                                            str("-") >> unaryExpression |
                                            str("~") >> unaryExpression |
                                            str("!") >> unaryExpression }
    rule(:multiplicativeExpression)         { unaryExpression >> (space? >> (str("*") | str("/") | str("%")) >> space? >> unaryExpression).repeat(1).maybe }
    rule(:multiplicativeExpressionNoBF)     { unaryExpressionNoBF >> (space? >> (str("*") | str("/") | str("%")) >> space? >> unaryExpression).repeat(1).maybe }
    rule(:additiveExpression)               { multiplicativeExpression >> (space? >> (str("+") | str("-")) >> space? >> multiplicativeExpression).repeat(1).maybe }
    rule(:additiveExpressionNoBF)           { multiplicativeExpressionNoBF >> (space? >> (str("+") | str("-")) >> space? >> multiplicativeExpression).repeat(1).maybe }
    rule(:shiftExpression)                  { additiveExpression >> (space? >> (str(">>>") | str(">>") | str("<<")) >> space? >> additiveExpression).repeat(1).maybe }
    rule(:shiftExpressionNoBF)              { additiveExpressionNoBF >> (space? >> (str(">>>") | str(">>") | str("<<")) >> space? >> additiveExpression).repeat(1).maybe }
    rule(:relationalExpression)             { shiftExpression >> (space? >> (str("<=") | str(">=") | str("<") | str(">") | str("instanceof") | str("in")) >> space? >> shiftExpression).repeat(1).maybe }
    rule(:relationalExpressionNoIn)         { shiftExpression >> (space? >> (str("<=") | str(">=") | str("<") | str(">") | str("instanceof")) >> space? >> shiftExpression).repeat(1).maybe }
    rule(:relationalExpressionNoBF)         { shiftExpressionNoBF >> (space? >> (str("<=") | str(">=") | str("<") | str(">") | str("instanceof") | str("in")) >> space? >> shiftExpression).repeat(1).maybe }
    rule(:equalityExpression)               { relationalExpression >> (space? >> (str("==")|str("!==")|str("!=")) >> space? >> relationalExpression).repeat(1).maybe }
    rule(:equalityExpressionNoIn)           { relationalExpressionNoIn >> (space? >> (str("===") | str("==") | str("!==") | str("!=")) >> space? >> relationalExpressionNoIn).repeat(1).maybe }
    rule(:equalityExpressionNoBF)           { relationalExpressionNoBF >> (space? >> (str("==")|str("!==")|str("!=")) >> space? >> relationalExpression).repeat(1).maybe }
    rule(:bitwiseANDExpression)             { equalityExpression >> (blank? >> str("&") >> blank? >> equalityExpression).repeat(1).maybe }  
    rule(:bitwiseANDExpressionNoIn)         { equalityExpressionNoIn >> (blank? >> str("&") >> blank? >> equalityExpressionNoIn).repeat(1).maybe }  
    rule(:bitwiseANDExpressionNoBF)         { equalityExpressionNoBF >> (blank? >> str("&") >> blank? >> equalityExpression).repeat(1).maybe }
    rule(:bitwiseXORExpression)             { bitwiseANDExpression >> (blank? >> str("^") >> blank? >> bitwiseANDExpression).repeat(1).maybe }
    rule(:bitwiseXORExpressionNoIn)         { bitwiseANDExpressionNoIn >> (blank? >> str("^") >> blank? >> bitwiseANDExpressionNoIn).repeat(1).maybe }
    rule(:bitwiseXORExpressionNoBF)         { bitwiseANDExpressionNoBF >> (blank? >> str("^") >> blank? >> bitwiseANDExpression).repeat(1).maybe }
    rule(:bitwiseORExpression)              { bitwiseXORExpression >> (blank? >> str("|") >> blank? >> bitwiseXORExpression).repeat(1).maybe }
    rule(:bitwiseORExpressionNoIn)          { bitwiseXORExpressionNoIn >> (blank? >> str("|") >> blank? >> bitwiseXORExpressionNoIn).repeat(1).maybe }
    rule(:bitwiseORExpressionNoBF)          { bitwiseXORExpressionNoBF >> (blank? >> str("|") >> blank? >> bitwiseXORExpression).repeat(1).maybe }
    rule(:logicalANDExpression)             { bitwiseORExpression >> (blank? >> str("&&") >> blank? >> bitwiseORExpression).repeat(1).maybe } 
    rule(:logicalANDExpressionNoIn)         { bitwiseORExpressionNoIn >> (blank? >> str("&&") >> blank? >> bitwiseORExpressionNoIn).repeat(1).maybe }
    rule(:logicalANDExpressionNoBF)         { bitwiseORExpressionNoBF >> (blank? >> str("&&") >> blank? >> bitwiseORExpression).repeat(1).maybe } 
    rule(:logicalORExpression)              { logicalANDExpression >> (blank? >> str("||") >> blank? >> logicalANDExpression).repeat(1).maybe }
    rule(:logicalORExpressionNoIn)          { logicalANDExpressionNoIn >> (blank? >> str("||") >> blank? >> logicalANDExpressionNoIn).repeat(1).maybe } 
    rule(:logicalORExpressionNoBF)          { logicalANDExpressionNoBF >> (blank? >> str("||") >> blank? >> logicalANDExpression).repeat(1).maybe } 
    rule(:conditionalExpression)            { logicalORExpression >> (space? >> str("?") >> space? >> assignmentExpression >> space? >> str(":") >> blank? >> assignmentExpression).maybe }
    rule(:conditionalExpressionNoIn)        { logicalORExpressionNoIn >> (space? >> str("?") >> space? >> assignmentExpression >> space? >> str(":") >> blank? >> assignmentExpressionNoIn).maybe }
    rule(:conditionalExpressionNoBF)        { logicalORExpressionNoBF >> (space? >> str("?") >> space? >> assignmentExpression >> space? >> str(":") >> blank? >> assignmentExpression).maybe }
    rule(:assignmentExpression)             { leftHandSideExpression.as(:LFS_EXP) >> blank? >> str("=") >> blank? >> assignmentExpression |
                                            leftHandSideExpression >> blank? >> assignmentOperator >> blank? >> assignmentExpression |
                                            conditionalExpression}
    rule(:assignmentExpressionNoIn)         { leftHandSideExpression.as(:LHS_EXP) >> blank? >> str("=") >> blank? >> assignmentExpressionNoIn.as(:ASSIGN_EXP_NOIN) |
                                            leftHandSideExpression.as(:LHS_EXP) >> blank? >> assignmentOperator >> blank? >> assignmentExpressionNoIn.as(:ASSIGN_EXP_NOIN) | conditionalExpressionNoIn }
    rule(:assignmentExpressionNoBF)         { leftHandSideExpressionNoBF >> blank? >> str("=") >> blank? >> assignmentExpression |
                                            leftHandSideExpressionNoBF >> blank? >> assignmentOperator >> blank? >> assignmentExpression |
                                            conditionalExpressionNoBF}
    rule(:assignmentOperator)               { str("*=") | str("/=") | str("%=") | str("+=") | str("-=") | str("<<=") | str(">>=") | str("&=") | str("^=") | str("|=") }
    rule(:expression)                       { assignmentExpression >> (blank? >> str(",") >> blank? >> assignmentExpression).repeat(1).maybe }
    rule(:expressionNoIn)                   { assignmentExpressionNoIn >> (blank? >> str(",") >> blank? >> assignmentExpressionNoIn).repeat(1).maybe }
    rule(:expressionNoBF)                   { assignmentExpressionNoBF >> (blank? >> str(",") >> blank? >> assignmentExpression).repeat(1).maybe }
    rule(:literal)                          { nullLiteral | booleanLiteral | numericLiteral | stringLiteral | regularExpressionLiteral }   
    rule(:nullLiteral)                      { str("null") }
    rule(:booleanLiteral)                   { str("true") | str("false") }
    rule(:numericLiteral)                   { octalIntegerLiteral | hexIntegerLiteral | decimalIntegerLiteral }
    rule(:reservedWord)                     { str("break") | str("case") | str("catch") | str("continue") | str("debugger") | str("default") | str("delete") | str("do") | str("else") | str("finally") | str("for") | str("function") | str("if") | str("in") | str("instanceof") | str("new") | str("return") | str("switch") | str("this") | str("throw") | str("try") | str("typeof") | str("var") | str("void") | str("while") | str("with") | str("true") | str("false") | str("null") | str("class") | str("const") | str("enum") | str("export") | str("extends") | str("import") | str("super") }
    rule(:domEvent)                         { str("addeventlistener") | str("onclick") | str("on contextmenu") | str("ondblclick") | str("onmousedown") | str("onmouseenter") | str("onmouseleave") | str("onmousemove") | str("onmouseover") | str("onmouseout") | str("onmouseup") | str("onkeydown") | str("onkeypress") | str("onkeyup") | str("onabort") | str("onbeforeunload") | str("onerror") | str("onhashchange") | str("onload") | str("onpageshow") | str("onpagehide") | str("onresize") | str("onscroll") | str("onunload") | str("onblur") | str("onchange") | str("onfocus") | str("onfocusin") | str("onfocusout") | str("oninput") | str("oninvalid") | str("onreset") | str("onsearch") | str("onselect") | str("onsubmit") | str("ondrag") | str("ondragend") | str("ondragenter") | str("ondragleave") | str("ondragover") | str("ondragstart") | str("ondrop") | str("oncopy") | str("oncut") | str("onpaste") | str("onafterprint") | str("onbeforeprint") | str("onabort") | str("oncanplay") | str("oncanplaythrough") | str("ondurationchange") | str("onemptied") | str("onended") | str("onerror") | str("onloadeddata") | str("onloadedmetadata") | str("onloadstart") | str("onpause") | str("onplay") | str("onplaying") | str("onprogress") | str("onratechange") | str("onseeked") | str("onseeking") | str("onstalled") | str("onsuspend") | str("ontimeupdate") | str("onvolumechange") | str("onwaiting") | str("animationend") | str("animationiteration") | str("animationstart") | str("transitionend") | str("onerror") | str("onmessage") | str("onopen") | str("onmessage") | str("onmousewheel") | str("ononline") | str("onoffline") | str("onpopstate") | str("onshow") | str("onstorage") | str("ontoggle") | str("onwheel") | str("ontouchcancel") | str("ontouchend") | str("ontouchmove") | str("ontouchstart") }
    
end

def parseEcma(str)
  miniEcma = MiniEcma.new
  
  miniEcma.parse(str)
rescue Parslet::ParseFailed => failureEcma
  puts failureEcma.cause.ascii_tree
end

archivo = File.read('/home/abel/parslet.js')
#archivo = File.read('/media/abel/Datos/Programación/Ruby/Parslet/htmlparser.js')
#pp archivo
cadena="function obtenerXHR() {
req = false;
if (XMLHttpRequest){
req = new XMLHttpRequest()
}else{
req = new ActiveXObject('MSXML2.XMLHttp.5.0')
}
}"
#pp cadena
#id = parse archivo.downcase
#id = parse cadena.downcase
#pp id

class TransformerEcma < Parslet::Transform
    #los patterns de las rule deben contener todos los elementos (:elemento) del mismo nivel de jerarquía, de lo contrario no funcionará
    rule(:XMLHTTP => simple(:x)){
        xObj={}
        res={}
        xObj[:TYPE] = x
        xObj[:POS] = x.line_and_column
        res[:XOBJ]= xObj
        res
        }
    rule(:DOM_EV => simple(:x)){
        res={}
        res[:CONTROLLER]=x.line_and_column
        res
        }
    rule(:STAT => simple(:x)){
        }
    rule(:FN_DEC => subtree(:x)){
        x
        }
#    rule(:STAT => subtree(:x)){
#        if !x.blank?
#            x
#        end
#        }
#    rule(:FN_DEC => subtree(:x)) { 
#        res = {}
#        #res[:hola]= String(x)   #+line
#        #res[:chau]= String(y)+"qw"  #+col   #con esto se convierte el valor del token a cadena
#        res[:FN_NAME]= x[0][:IDENTIFIER]
#        res[:FN_POS]= x[0][:IDENTIFIER].line_and_column    #con esto se puede obtener la ubicación del token en la cadena de entrada
#        #arr = []
#        #arr << [:hola=> String(x)]
#        #arr << [:chau=> String(y)]
#        #res[:arr] = arr
#        #html_op = []
#        #html_op = {:token => String(x), :pos => x.line_and_column}
#        #res[:html_op] = html_op
#        res
#    }
#    rule(:FUNC_EXP => subtree(:x)) { 
#        res = {}
#        fnCont = x[0][:IDENTIFIER]
#        if fnCont
#        #res[:hola]= String(x)   #+line
#        #res[:chau]= String(y)+"qw"  #+col   #con esto se convierte el valor del token a cadena
#            res[:FN_NAME]= fnCont
##            res[:FN_POS]= x[0][:IDENTIFIER].line_and_column    #con esto se puede obtener la ubicación del token en la cadena de entrada
#        else
#            res[:FN_NAME]= "namen"
#        end
#        res
#    }
  
end
#
#optimus = Transformer.new.apply(id)
#pp optimus