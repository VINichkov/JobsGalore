!function (e) {
    var t = window["pcodeLoaderJsonp10205"];
    window["pcodeLoaderJsonp10205"] = function (n, o, i) {
        for (var a, c, s = 0, u = []; s < n.length; s++) c = n[s], r[c] && u.push(r[c][0]), r[c] = 0;
        for (a in o) Object.prototype.hasOwnProperty.call(o, a) && (e[a] = o[a]);
        for (t && t(n, o, i); u.length;) u.shift()()
    };
    var n = {}, r = {1: 0};

    function o(t) {
        if (n[t]) return n[t].exports;
        var r = n[t] = {i: t, l: !1, exports: {}};
        return e[t].call(r.exports, r, r.exports, o), r.l = !0, r.exports
    }

    o.e = function (e) {
        var t = r[e];
        if (0 === t) return new Promise(function (e) {
            e()
        });
        if (t) return t[2];
        var n = new Promise(function (n, o) {
            t = r[e] = [n, o]
        });
        t[2] = n;
        var i = document.getElementsByTagName("head")[0], a = document.createElement("script");
        a.type = "text/javascript", a.charset = "utf-8", a.async = !0, a.timeout = 12e4, o.nc && a.setAttribute("nonce", o.nc), a.src = o.p + "" + {0: "09a36b2a9bb7b4713e12"}[e] + ".js";
        var c = setTimeout(s, 12e4);

        function s() {
            a.onerror = a.onload = null, clearTimeout(c);
            var t = r[e];
            0 !== t && (t && t[1](new Error("Loading chunk " + e + " failed.")), r[e] = void 0)
        }

        return a.onerror = a.onload = s, i.appendChild(a), n
    }, o.m = e, o.c = n, o.d = function (e, t, n) {
        o.o(e, t) || Object.defineProperty(e, t, {configurable: !1, enumerable: !0, get: n})
    }, o.n = function (e) {
        var t = e && e.__esModule ? function () {
            return e["default"]
        } : function () {
            return e
        };
        return o.d(t, "a", t), t
    }, o.o = function (e, t) {
        return Object.prototype.hasOwnProperty.call(e, t)
    }, o.p = "https://an.yandex.ru/partner-code-bundles/10205/", o.oe = function (e) {
        throw console.error(e), e
    }, o(o.s = 73)
}([function (e, t, n) {
    "use strict";

    function r() {
        return window.Ya || (window.Ya = t.initYa())
    }

    function o() {
        var e = r();
        return e.Context || (e.Context = t.initYaContext())
    }

    t.__esModule = !0, t.setGlobalVariable = function (e, t) {
        o()[e] = t
    }, t.getGlobalVariable = function (e) {
        return o()[e]
    }, t.getYa = r, t.getYaContext = o, t.initYaContext = function () {
        return {
            isAllowedRepeatAds: n(79).isAllowedRepeatAds,
            _load_callbacks: [],
            _callbacks: [],
            _asyncIdCounter: 0,
            _asyncModeOn: Boolean(document.currentScript && document.currentScript.async),
            initTime: Number(new Date),
            longExp: {
                getId: function () {
                    return ""
                }
            },
            LOG_DIRECT: n(3).isPercent(1)
        }
    }, t.initYaDirect = function () {
        return {
            insertInto: function (e, t, n, r) {
                var i = o();
                i._asyncModeOn || (i._asyncModeOn = !0), i.AdvManager.renderDirect(e, t, n, r)
            }
        }
    }, t.initYa = function () {
        return {Direct: t.initYaDirect(), Context: t.initYaContext()}
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.experimentIds = {
        ssSkipToken: {
            ENABLED: "SS_SKIP_TOKEN_ENABLED",
            WIDE_LOG: "SS_SKIP_TOKEN_WIDE_LOG",
            CLIENT: "SS_SKIP_TOKEN_CLIENT",
            SERVER_MANUAL: "SS_SKIP_TOKEN_SERVER_MANUAL",
            SERVER_AUTO: "SS_SKIP_TOKEN_SERVER_AUTO"
        },
        smartCrop: {ALLOWED: "SMART_CROP_ALLOWED", ENABLED: "SMART_CROP_ENABLED", DISABLED: "SMART_CROP_DISABLED"},
        similarButton: {ENABLED: "SIMILAR_BUTTON_ENABLED"},
        geoSkin: {
            V1: "GEO_SKIN_VERSION_1",
            V2: "GEO_SKIN_VERSION_2",
            V3: "GEO_SKIN_VERSION_3",
            DISABLED: "GEO_SKIN_VERSION_DISABLED"
        },
        priceInText: {ENABLED: "PRICE_IN_TEXT_ENABLED", DISABLED: "PRICE_IN_TEXT_DISABLED"},
        sendBeaconExp: {
            SENDBEACON: "SENDBEACON_EXP_SENDBEACON",
            XHR: "SENDBEACON_EXP_XHR",
            CONTROL: "SENDBEACON_EXP_CONTROL",
            DISABLED: "SENDBEACON_EXP_DISABLED"
        },
        motionBigTitle: {
            DEFAULT_DISABLED: "BIG_TITLE_IN_MOTION_DEFAULT_DISABLED",
            ENABLED_NORMAL: "BIG_TITLE_IN_MOTION_ENABLED_NORMAL",
            ENABLED_WITH_MARKER: "BIG_TITLE_IN_MOTION_ENABLED_WITH_MARKER",
            DISABLED_CONTROL: "BIG_TITLE_IN_MOTION_DISABLED_CONTROL"
        },
        clickDelayWiFi: {ENABLED: "CLICK_DELAY_ENABLED", DISABLED: "CLICK_DELAY_DISABLED"}
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.PARSE_LINK_ELEMENT = document.createElement("a")
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0;
    var r = 2;

    function o(e) {
        return i(e / 100)
    }

    function i(e) {
        return Number(e.toFixed(r))
    }

    t.prepare = function (e) {
        for (var t, n = [], r = 0, a = 0; a < e.length; a++) r = t = i(o(e[a].percent) + r), n.push({
            id: e[a].id,
            extra: e[a].extra,
            threshold: t
        });
        return n
    }, t.toFraction = o, t.fixPrecision = i, t.findDefault = function (e) {
        for (var t = null, n = 0; n < e.length; n++) (!t || t.percent < e[n].percent) && (t = e[n]);
        return t
    }, t.isPercent = function (e) {
        return Math.random() < o(e)
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.noop = function () {
        for (var e = [], t = 0; t < arguments.length; t++) e[t] = arguments[t]
    }
}, function (e, t, n) {
    "use strict";

    function r() {
        for (var e = [], t = 0; t < arguments.length; t++) e[t] = arguments[t];
        return e.join("")
    }

    t.__esModule = !0, t.callSafe = function (e) {
        try {
            return e()
        } catch (e) {
            return
        }
    }, t.protect = function (e, r, o, i) {
        return function () {
            try {
                return r.apply(o || this, arguments)
            } catch (r) {
                if (n(8).isFunction(i) && i(r), !0 === r.preventProtect) throw r;
                t.protect.log(r, e)
            }
        }
    }, t.rethrowAsync = function (e, n) {
        setTimeout(function () {
            t.protect.log(e, n)
        })
    }, t.protect.log = function (e, t) {
        console.log("LOG:" + t + ":" + e)
    }, t.protect.setTimeout = function (e, n, r, o) {
        return window.setTimeout(t.protect("timeout", e, r, o), n)
    };
    var o = function () {
        function e() {
        }

        return e.YaContextCallbacks = r("Ya.C", "ontext._callbacks"), e.YaContextCallbacksCalls = r("Ya.C", "ontext._callbacks_call"), e.AdvManager = r("A", "dvManager"), e.AdvBlock = r("A", "dvBlock"), e.RTB = r("R", "TB"), e.Rtb = r("R", "tb"), e.MetrikaAdtune = r("metrika_a", "dtune"), e
    }();
    t.ProtectedNames = o
}, function (e, t, n) {
    "use strict";
    var r;
    t.__esModule = !0, function (e) {
        e["SSP"] = "ssp", e["mobileSdk"] = "msdk"
    }(r = t.bundleTypes || (t.bundleTypes = {}));
    var o = "bundleType";
    t.saveBundleType = function (e) {
        var t;
        n(0).getGlobalVariable(o) || (n(7).isObject(e) ? (i = e, t = i && i.common && i.common.sspId && Boolean(Number(i.common.sspId)) ? r.SSP : i && i.common && 1 === Number(i.common.isMobileSdk) ? r.mobileSdk : void 0) : n(17).isString(e) && (t = function (e) {
            var t;
            switch (e) {
                case"ssp":
                    t = r.SSP;
                    break;
                case"mobsdk":
                    t = r.mobileSdk;
                    break;
                default:
                    t = void 0
            }
            return t
        }(e)), t && n(0).setGlobalVariable(o, t));
        var i
    }, t.checkBundleType = function (e) {
        switch (e) {
            case r.SSP:
                return n(44).isSspPage(window) || n(0).getGlobalVariable(o) === e;
            default:
                return n(0).getGlobalVariable(o) === e
        }
    }
}, function (e, t, n) {
    "use strict";
    var r = "function" == typeof Symbol && "symbol" == typeof Symbol.iterator ? function (e) {
        return typeof e
    } : function (e) {
        return e && "function" == typeof Symbol && e.constructor === Symbol && e !== Symbol.prototype ? "symbol" : typeof e
    };
    t.__esModule = !0, t.isObject = function (e) {
        var t = void 0 === e ? "undefined" : r(e);
        return Boolean(e) && ("object" === t || "function" === t)
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.isFunction = function (e) {
        return "function" == typeof e || "Function" === n(23).getInternalClass(e)
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.SESSION_KEY = "sessionId"
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.logger = n(110).logger
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.getIsCompatibilityMode = function () {
        var e = n(35).getVersion();
        return 9636 === e || 5699 === e || 5836 === e
    };
    var r = n(0).getYaContext();
    t.getCallbacksArrayName = function () {
        return t.getIsCompatibilityMode() ? "_callbacks" : Boolean(r._load_callbacks) ? "_load_callbacks" : "_callbacks"
    }, t.getCallbacksArray = function () {
        return t.getIsCompatibilityMode() ? r._callbacks : r._load_callbacks || r._callbacks
    }
}, function (e, t, n) {
    "use strict";

    function r(e) {
        var t = window, n = t[e];
        return t[e] = void 0, n
    }

    function o(e, t) {
        return r("yandex_" + (t ? t + "_" : "") + e)
    }

    t.__esModule = !0, t.extractProp = r, t.extractPrefixedProp = o, t.extractSettings = function (e, t, n) {
        for (var r = 0; r < t.length; r++) e[t[r]] = o(t[r], n)
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0;
    var r = n(32).memoize(function (e) {
        return {search: n(33).parseQueryString(e.search), hash: n(33).parseQueryString(e.hash)}
    }), o = 512;
    t.getUrlParameter = function (e) {
        var t = e.paramName, n = e.location, o = void 0 === n ? window.location : n, i = e.valueTransform,
            a = void 0 === i ? function (e) {
                return e
            } : i, c = r(o), s = c.search, u = c.hash;
        return a(t in s ? s[t] : t in u ? u[t] : "")
    };
    var i = function (e, n) {
        return t.getUrlParameter({
            paramName: e, location: n, valueTransform: function (e) {
                return parseInt(e, 10) || void 0
            }
        })
    };

    function a(e) {
        return parseInt(window[e], 10) || void 0
    }

    t.getAdditionalBanners = function (e) {
        void 0 === e && (e = window.location);
        var n = t.getUrlParameter({paramName: "additional-banners", location: e});
        return decodeURIComponent(n)
    }, t.getUrlDebugParameters = function (e) {
        void 0 === e && (e = window.location);
        try {
            var r = n(58).getNativeJSON(),
                i = decodeURIComponent(t.getUrlParameter({paramName: "ya-debug-params", location: e}));
            if (!i) return {};
            var a = r.parse(i);
            return n(59).reduce(n(52).getObjectKeys(a), function (e, t) {
                return function (e, t) {
                    return !!(n(17).isString(e) && n(17).isString(t) && e.length + t.length < o)
                }(t, a[t]) && (e[t] = a[t]), e
            }, {})
        } catch (e) {
            return {}
        }
    }, t.debugParameters = t.getUrlDebugParameters(), t.getUrlCodeVersions = function (e) {
        void 0 === e && (e = window.location);
        return {pcode: i("pcodever", e) || a("pcodever"), media: i("mcodever", e) || a("mcodever")}
    }, t.urlCodeVersions = t.getUrlCodeVersions(), t.getPcodeDebugFlag = function (e) {
        return void 0 === e && (e = window.location), t.getUrlParameter({
            paramName: "pcodeDebug",
            location: e,
            valueTransform: Boolean
        })
    }, t.pcodeDebugFlag = t.getPcodeDebugFlag()
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, function (e) {
        e["event"] = "event", e["error"] = "error", e["deprecated"] = "deprecated", e["warning"] = "warning", e["value"] = "value", e["values"] = "values"
    }(t.StatsEventType || (t.StatsEventType = {}))
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0;
    var r = function () {
        function e(e) {
            this.obj = e
        }

        return e.prototype.getItem = function (e) {
            return this.obj[e]
        }, e.prototype.setItem = function (e, t) {
            this.obj[e] = t
        }, e
    }();
    t.ObjectStorage = r
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.checkNativeCode = function (e) {
        if (!e || !e.toString) return !1;
        var t = e.toString();
        return /\[native code\]/.test(t) || /\/\* source code not available \*\//.test(t)
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.isString = function (e) {
        return "string" == typeof e
    }
}, function (e, t, n) {
    "use strict";

    function r() {
        return parseInt(n(0).getYa().codeVer, 10) || 0
    }

    t.__esModule = !0, t.getCodeVersion = r, t.getRevisionNo = function () {
        return r() % 1024
    }
}, function (e, t, n) {
    "use strict";
    var r;
    t.__esModule = !0, t.getSessionId = function () {
        return r || (r = n(119).getSession(n(120).generateSessionId, n(47).getWindowStorage("common"), n(22).getCrossFrameStorage("common"), n(48).configureMetrika)), r
    }, t.setSessionId = function (e) {
        r !== e && (n(125).setSession(e, n(47).getWindowStorage("common"), n(22).getCrossFrameStorage("common"), n(48).configureMetrika), r = e)
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.once = function (e) {
        var t = function () {
            t = function () {
                return n
            };
            var n = e.apply(this, arguments);
            return n
        };
        return function () {
            return t.apply(this, arguments)
        }
    }
}, function (e, t, n) {
    "use strict";
    var r = function () {
        return (r = Object.assign || function (e) {
            for (var t, n = 1, r = arguments.length; n < r; n++) for (var o in t = arguments[n]) Object.prototype.hasOwnProperty.call(t, o) && (e[o] = t[o]);
            return e
        }).apply(this, arguments)
    };
    t.__esModule = !0;
    var o = 200, i = 4;
    t.request = function e(t) {
        var a, c, s = t.method, u = t.url, l = t.async, d = void 0 === l || l, f = t.data, p = t.responseType,
            _ = void 0 === p ? "text" : p, m = t.onBeforeSend, g = void 0 === m ? n(4).noop : m, h = t.onError,
            v = void 0 === h ? n(4).noop : h, y = t.onSuccess, E = void 0 === y ? n(4).noop : y, S = t.onRetry,
            b = void 0 === S ? n(4).noop : S, I = t.checkStatus, M = void 0 === I ? function (e) {
                return o === e
            } : I, w = t.headers, C = void 0 === w ? {} : w, k = t.xhrConstructor, x = void 0 === k ? XMLHttpRequest : k,
            O = t.retries, T = void 0 === O ? 0 : O, A = t.timeout, N = void 0 === A ? 0 : A, D = t.withCredentials,
            L = t.onAbort, P = t.onSetup, R = !1, B = function (e) {
                R = !0, B = n(4).noop, a = e, j(new Error("Abort request")), "function" == typeof L && L(e)
            }, j = function (o) {
                if (Y.onerror = null, Y.onreadystatechange = null, c && clearTimeout(c), c && Y.readyState !== i || R) try {
                    Y.abort()
                } catch (o) {
                }
                if (!R) if (T > 0) {
                    var s = b(o, Y);
                    if ("boolean" != typeof s || s || B(), R) return;
                    e(r(r({}, t), {
                        onSetup: function (e) {
                            var t = e.abort;
                            B = function (e) {
                                return t(e)
                            }, R && t(a)
                        }, retries: T - 1
                    }))
                } else B = n(4).noop, v(o, Y)
            }, Y = new x;
        try {
            Y.open(s, u, d)
        } catch (e) {
            return void j(e)
        }
        if (Y.responseType = _, Y.withCredentials = Boolean(D), n(34).forOwn(C, function (e, t) {
            try {
                Y.setRequestHeader(t, e)
            } catch (e) {
            }
        }), N > 0 && isFinite(N) && (c = window.setTimeout(function () {
            j(new Error("Request timeout, " + u))
        }, N)), Y.onerror = j, Y.onreadystatechange = function () {
            if (Y.readyState === i) {
                var e = Y.status;
                M(e) ? (B = n(4).noop, clearTimeout(c), E(Y)) : j(new Error("Invalid request status " + e + ", " + u))
            }
        }, !("function" == typeof P && (P({
            abort: function (e) {
                return B(e)
            }
        }), R) || (g(Y, t), R))) try {
            Y.send(f)
        } catch (e) {
            j(e)
        }
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0;
    var r = n(20).once(function () {
        return n(82).getCrossFrameDataSource(self, "Ya.pcodeCrossFrameData", function () {
            return new (n(15).ObjectStorage)({})
        })
    });
    t.getCrossFrameStorage = function (e) {
        return n(39).getOrCreateItem(r(), e, function () {
            return new (n(15).ObjectStorage)({})
        })
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0;
    var r = {}.toString, o = /\[object (\w+)\]/;
    t.getInternalClass = function (e) {
        var t = r.call(e);
        if (!t) return null;
        var n = t.match(o);
        if (!n) return null;
        var i = n[1];
        return i || null
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.get = function (e, t) {
        for (var r = 0, o = t.split("."); r < o.length; r++) {
            var i = o[r];
            if (!n(7).isObject(e)) {
                e = void 0;
                break
            }
            e = e[i]
        }
        return e
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.set = function (e, t, r) {
        if (!n(7).isObject(e)) return e;
        for (var o = e, i = t.split("."), a = i.pop(), c = 0, s = i; c < s.length; c++) {
            var u = s[c], l = e[u];
            e = n(7).isObject(l) ? l : e[u] = {}
        }
        return e[a] = r, o
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.prefixes = ["", "webkit", "moz", "o", "ms"], t.cssPrefixes = ["", "-webkit-", "-ms-", "-moz-", "-o-"]
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.forEach = function (e, t, n) {
        for (var r = 0; r < e.length; r++) t.call(n, e[r], r, e)
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.parseBlockId = function (e) {
        var t = /^(\w{1,2})-(?:\w+-)?(\d+)-(\d+|\w+)$/.exec(e);
        return {product: t ? t[1] : null, pageId: t ? t[2] : null, impId: t ? t[3] : null}
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0;
    var r = [];

    function o(e) {
        return 0 === e.indexOf(t.FAKE_IMP_ID)
    }

    t.FAKE_IMP_ID = "100500", t.generateImpId = function (e) {
        var n = r.indexOf(e);
        return -1 === n && (n = r.length, r.push(e)), t.FAKE_IMP_ID + "_" + n
    }, t.isFakeImpId = o, t.getRealImpId = function (e) {
        return o(e) ? t.FAKE_IMP_ID : e
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.map = function (e, t, n) {
        for (var r = new Array(e.length), o = 0; o < e.length; o++) r[o] = t.call(n, e[o], o, e);
        return r
    }
}, function (e, t, n) {
    "use strict";
    var r = "function" == typeof Symbol && "symbol" == typeof Symbol.iterator ? function (e) {
        return typeof e
    } : function (e) {
        return e && "function" == typeof Symbol && e.constructor === Symbol && e !== Symbol.prototype ? "symbol" : typeof e
    };
    t.__esModule = !0, t.isHomePage = function (e) {
        return -1 !== e.location.hostname.indexOf("yandex") && "object" === r(e.home) && Boolean(e.home["export"])
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0;
    var r = function () {
        function e(e) {
            this.cache = e
        }

        return e.prototype.get = function (e) {
            return this.cache[e]
        }, e.prototype.has = function (e) {
            return e in this.cache
        }, e.prototype.set = function (e, t) {
            this.cache[e] = t
        }, e
    }();
    t.ObjectCache = r, t.memoize = function (e, t, n) {
        return void 0 === t && (t = function (e) {
            return e
        }), void 0 === n && (n = new r({})), function () {
            var r = t.apply(this, arguments);
            if (n.has(r)) return n.get(r);
            var o = e.apply(this, arguments);
            return n.set(r, o), o
        }
    }
}, function (e, t, n) {
    "use strict";
    var r = function () {
        return (r = Object.assign || function (e) {
            for (var t, n = 1, r = arguments.length; n < r; n++) for (var o in t = arguments[n]) Object.prototype.hasOwnProperty.call(t, o) && (e[o] = t[o]);
            return e
        }).apply(this, arguments)
    };
    t.__esModule = !0;
    var o = "//", i = 2;

    function a(e) {
        n(2).PARSE_LINK_ELEMENT.href = e;
        var t = n(2).PARSE_LINK_ELEMENT.pathname || "";
        "/" !== t.charAt(0) && (t = "/" + t);
        var r = (n(2).PARSE_LINK_ELEMENT.search || "") + (n(2).PARSE_LINK_ELEMENT.hash || ""), o = e.lastIndexOf(r),
            i = -1 === o ? e : e.slice(0, o),
            a = n(2).PARSE_LINK_ELEMENT.protocol && /^[a-z]+:/i.test(n(2).PARSE_LINK_ELEMENT.protocol) ? n(2).PARSE_LINK_ELEMENT.protocol : "";
        return {
            originalPath: i,
            href: n(2).PARSE_LINK_ELEMENT.href,
            protocol: a,
            host: n(2).PARSE_LINK_ELEMENT.host,
            hostname: n(2).PARSE_LINK_ELEMENT.hostname,
            port: n(2).PARSE_LINK_ELEMENT.port,
            pathname: t,
            search: n(2).PARSE_LINK_ELEMENT.search,
            hash: n(2).PARSE_LINK_ELEMENT.hash
        }
    }

    function c(e, t) {
        if (void 0 === t && (t = !1), t) {
            var n = e.originalPath, r = "/" === e.pathname && "/" !== n[n.length - 1];
            return e.originalPath + (r ? "/" : "") + e.search + e.hash
        }
        var o = "443" === e.port || "80" === e.port ? e.hostname : e.host;
        return e.protocol + "//" + o + e.pathname + e.search + e.hash
    }

    t.parseUrlUsingCache = n(32).memoize(function (e) {
        var t = a(e);
        return r({}, t)
    }), t.parseUrl = a, t.urlFromUrlObject = c;
    var s = function (e) {
        try {
            return decodeURIComponent(e)
        } catch (t) {
            return e
        }
    };

    function u(e) {
        for (var t = {}, n = e.replace(/^[?#]+/, "").replace(/#.*$/, "").split("&"), r = 0; r < n.length; r++) {
            var o = n[r].indexOf("="), i = void 0, a = void 0;
            if (-1 === o ? (i = s(n[r]), a = "") : (i = s(n[r].slice(0, o)), a = n[r].slice(o + 1)), i) {
                var c = Boolean(/(\[\])$/.exec(i));
                i = i.replace(/\[\]$/, ""), c ? void 0 === t[i] ? t[i] = [s(a)] : t[i] = [].concat(t[i], s(a)) : t[i] = s(a)
            }
        }
        return t
    }

    t.parseQueryString = u, t.getParamsFromUrl = function (e) {
        return u(a(e).search)
    };
    var l = function (e, t) {
        return t.map(function (t) {
            return e + "[]=" + encodeURIComponent(t)
        }).join("&")
    };

    function d(e) {
        var t = [];
        for (var r in e) if (e.hasOwnProperty(r)) {
            var o = e[r];
            n(87).isArray(o) ? t.push(l(r, o)) : void 0 !== o && t.push(r + "=" + encodeURIComponent(o))
        }
        return "?" + t.join("&")
    }

    function f(e) {
        return a(e).pathname.split("/").pop() || ""
    }

    t.formatQueryString = d, t.addParamToUrl = function (e, t, n) {
        if (void 0 === n) return e;
        var o = a(e), i = u(o.search);
        return i[t] = n, c(r(r({}, o), {search: d(i)}))
    }, t.addParamsToUrl = function (e, t, o) {
        var i = void 0 === o ? {} : o, s = i.override, l = void 0 === s || s, f = i.saveOriginalPath,
            p = void 0 !== f && f, _ = a(e), m = u(_.search);
        n(34).forOwn(t, function (e, t) {
            (void 0 === m[t] || l) && (m[t] = e)
        });
        var g = d(m);
        return c(r(r({}, _), {search: g}), p)
    }, t.getPostProtocolIndex = function (e) {
        var t = e.indexOf(o);
        return -1 !== t ? t + i : 0
    }, t.getFileName = f, t.getFileExt = function (e) {
        var t = f(e).split(".");
        return t.length > 1 ? t.pop() : ""
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.forOwn = function (e, t, r) {
        for (var o in e) n(42).hasOwnProperty(e, o) && t.call(r, e[o], o, e)
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.global = window, t.Ya = n(0).getYa(), t.getVersion = function () {
        return parseInt(t.Ya.codeVer)
    }, t.getExp = function () {
        return t.Ya._exp
    }, t.getConfirmUrl = function () {
        return t.Ya.confirmUrl
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.getHead = function (e) {
        var t = e.document, n = t.getElementsByTagName("head")[0];
        return n || (n = t.createElement("head"), t.documentElement.appendChild(n)), n
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.random = n(121).IS_BROKEN_MATH_RANDOM ? n(122).pseudoRandom : function () {
        return Math.random()
    }
}, function (e, t) {
    var n;
    n = function () {
        return this
    }();
    try {
        n = n || Function("return this")() || (0, eval)("this")
    } catch (e) {
        "object" == typeof window && (n = window)
    }
    e.exports = n
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.getOrCreateItem = function (e, t, n) {
        var r = e.getItem(t);
        return r || (r = n(t), e.setItem(t, r)), r
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.murmurhash = function (e, t) {
        var n, r, o, i;
        void 0 === t && (t = 710033937);
        var a = 3 & e.length;
        n = e.length - a;
        var c = t, s = 3432918353, u = 461845907;
        for (i = 0; i < n;) o = 255 & e.charCodeAt(i) | (255 & e.charCodeAt(++i)) << 8 | (255 & e.charCodeAt(++i)) << 16 | (255 & e.charCodeAt(++i)) << 24, ++i, c = 27492 + (65535 & (r = 5 * (65535 & (c = (c ^= o = (65535 & (o = (o = (65535 & o) * s + (((o >>> 16) * s & 65535) << 16) & 4294967295) << 15 | o >>> 17)) * u + (((o >>> 16) * u & 65535) << 16) & 4294967295) << 13 | c >>> 19)) + ((5 * (c >>> 16) & 65535) << 16) & 4294967295)) + ((58964 + (r >>> 16) & 65535) << 16);
        switch (o = 0, a) {
            case 3:
                o ^= (255 & e.charCodeAt(i + 2)) << 16;
            case 2:
                o ^= (255 & e.charCodeAt(i + 1)) << 8;
            case 1:
                c ^= o = (65535 & (o = (o = (65535 & (o ^= 255 & e.charCodeAt(i))) * s + (((o >>> 16) * s & 65535) << 16) & 4294967295) << 15 | o >>> 17)) * u + (((o >>> 16) * u & 65535) << 16) & 4294967295
        }
        return c ^= e.length, c = 2246822507 * (65535 & (c ^= c >>> 16)) + ((2246822507 * (c >>> 16) & 65535) << 16) & 4294967295, c = 3266489909 * (65535 & (c ^= c >>> 13)) + ((3266489909 * (c >>> 16) & 65535) << 16) & 4294967295, (c ^= c >>> 16) >>> 0
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0;
    var r = function () {
        function e(e) {
            this.coin = this.flipCoin(), this.versions = n(3).prepare(e), this.defaultVersion = n(3).findDefault(e)
        }

        return e.prototype.flipCoin = function () {
            return Math.random()
        }, e.prototype.getId = function () {
            return this.get("id")
        }, e.prototype.getExtra = function () {
            return this.get("extra")
        }, e.prototype.getDefaultExtra = function () {
            return this.defaultVersion && this.defaultVersion.extra ? this.defaultVersion.extra : null
        }, e.prototype.getDefaultId = function () {
            return this.defaultVersion && this.defaultVersion.id ? this.defaultVersion.id : null
        }, e.prototype.get = function (e) {
            var t = this.choose();
            return t && t.hasOwnProperty(e) ? t[e] : null
        }, e.prototype.choose = function () {
            for (var e = null, t = 0; t < this.versions.length; t++) if (this.coin < this.versions[t].threshold) {
                e = this.versions[t];
                break
            }
            return e
        }, e
    }();
    t.Experiment = r
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.hasOwnProperty = function (e, t) {
        return Object.prototype.hasOwnProperty.call(e, t)
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0;
    var r = function () {
        "user strict";
        return !this
    }();
    t.isLegacyBrowser = !n(91).testProperty("display:flex") || !n(92).hasObjectDefineProperty || !r
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.isSspPage = function (e) {
        return Boolean(e.YA_SSP_PAGE)
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.isMatchingMediaQuery = function (e, t) {
        if (!n(8).isFunction(e.matchMedia)) return !1;
        var r = e.matchMedia(t);
        return n(7).isObject(r) && Boolean(r.matches)
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0;
    var r = Date && n(8).isFunction(Date.now);
    t.dateNow = r ? function () {
        return Date.now()
    } : function () {
        return (new Date).getTime()
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0;
    var r = n(20).once(function () {
        return n(68).getWindowDataSource(self, "Ya.pcodeWindowData", function () {
            return new (n(15).ObjectStorage)({})
        })
    });
    t.getWindowStorage = function (e) {
        return n(39).getOrCreateItem(r(), e, function () {
            return new (n(15).ObjectStorage)({})
        })
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.metrikaAdSessionLabel = "adSessionID", t.configureMetrika = n(5).protect("sessionId::configureMetrika", function (e, r) {
        var o;
        n(124).pushMetrikaEvent(e, ((o = {})[t.metrikaAdSessionLabel] = r, o))
    })
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, function (e) {
        e["AdvManagerLoader"] = "AdvManagerLoader", e["AdvManagerRender"] = "AdvManagerRender", e["ReadyForRendering"] = "ReadyForRendering", e["StartDomRendering"] = "StartDomRendering", e["Mounted"] = "Mounted", e["Layout"] = "Layout", e["Displayed"] = "Displayed", e["PostRendering"] = "PostRendering", e["Ready"] = "Ready"
    }(t.RenderMarks || (t.RenderMarks = {})), t.setMark = function (e, t) {
        try {
            var n = e + "_" + t;
            performance.mark(n)
        } catch (e) {
        }
    }, t.clearMarks = function (e) {
        try {
            var t = performance.getEntriesByType("mark");
            n(27).forEach(t, function (t) {
                0 === t.name.indexOf(e) && performance.clearMarks(t.name)
            })
        } catch (e) {
        }
    }, t.getMarksByName = function (e) {
        try {
            return performance.getEntriesByName(e, "mark")
        } catch (e) {
            return []
        }
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.getSourceUrl = function (e) {
        void 0 === e && (e = window);
        try {
            return e.location.hostname
        } catch (e) {
        }
        return ""
    }, t.getTargetRef = function (e) {
        void 0 === e && (e = window);
        try {
            return e.top.location.href
        } catch (e) {
        }
        try {
            return e.document.referrer || e.location.href
        } catch (e) {
        }
        return ""
    }, t.getPageRef = function (e) {
        void 0 === e && (e = window);
        try {
            return e.top.document.referrer
        } catch (e) {
        }
        return ""
    }, t.getHost = function (e) {
        void 0 === e && (e = window);
        try {
            return e.location.host
        } catch (e) {
        }
        return ""
    }, t.getHref = function (e) {
        void 0 === e && (e = window);
        try {
            return e.location.href
        } catch (e) {
        }
        return ""
    }, t.getHostWithPath = function (e) {
        void 0 === e && (e = window);
        try {
            return "" + e.location.hostname + e.location.pathname
        } catch (e) {
        }
        return ""
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.getNativeMethod = function (e, t) {
        var r = e[t];
        if (!n(16).checkNativeCode(r)) {
            var o = r;
            try {
                delete e[t];
                var i = e[t];
                "function" == typeof i && (r = i), e[t] = o
            } catch (e) {
            }
        }
        return r
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.getObjectKeys = function (e) {
        if ("function" == typeof Object.keys) return Object.keys(e);
        var t = [];
        for (var r in e) n(42).hasOwnProperty(e, r) && t.push(r);
        return t
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.filter = function (e, t, n) {
        for (var r = [], o = 0; o < e.length; o++) {
            var i = e[o];
            t.call(n, i, o, e) && r.push(i)
        }
        return r
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.some = function (e, t) {
        for (var n = 0; n < e.length; n++) if (t(e[n], n, e)) return !0;
        return !1
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.isTurboPage = function (e) {
        return void 0 === e && (e = window), Boolean(e.YA_TURBO_PAGES)
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.getElementById = function (e) {
        return document.getElementById(e)
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.listToArray = function (e) {
        if (!e) return [];
        for (var t = [], n = 0; n < e.length; n++) t.push(e[n]);
        return t
    }
}, function (e, t, n) {
    "use strict";
    var r;
    t.__esModule = !0, t.extractJSONFromIframe = function (e) {
        void 0 === e && (e = document.body);
        var t = n(88).createHiddenFriendlyIFrame(e);
        return {
            JSON: t.contentWindow.JSON, clean: function () {
                return n(90).removeIframe(t)
            }
        }
    }, t.getNativeJSON = function (e) {
        return void 0 === e && (e = window), void 0 === r && (r = i(e) ? e.JSON : {
            stringify: o("stringify"),
            parse: o("parse")
        }), r
    };
    var o = function (e) {
        return function (n) {
            var r = t.extractJSONFromIframe(), o = r.JSON, i = r.clean;
            try {
                return o[e](n)
            } finally {
                i()
            }
        }
    };

    function i(e) {
        return void 0 === e && (e = window), e.JSON && n(16).checkNativeCode(e.JSON.stringify) && n(16).checkNativeCode(e.JSON.parse)
    }

    t.checkNativeJSON = i
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.reduce = function (e, t, n) {
        var r = 0;
        for (arguments.length < 3 && (r = 1, n = e[0]); r < e.length; r++) n = t(n, e[r], r, e);
        return n
    }
}, function (e, t, n) {
    "use strict";
    var r = function () {
        return (r = Object.assign || function (e) {
            for (var t, n = 1, r = arguments.length; n < r; n++) for (var o in t = arguments[n]) Object.prototype.hasOwnProperty.call(t, o) && (e[o] = t[o]);
            return e
        }).apply(this, arguments)
    };
    t.__esModule = !0, t.setCookie = function (e, t, r, o) {
        void 0 === o && (o = {}), n(85).isDate(o.expires) && (o.expires = o.expires.toUTCString()), void 0 === o.path && (o.path = "/");
        var i = "";
        for (var a in o) o[a] && (i += "; " + a, !0 !== o[a] && (i += "=" + o[a]));
        try {
            var c = encodeURIComponent(String(t)) + "=" + encodeURIComponent(String(r));
            return e.cookie = c + i
        } catch (e) {
            return
        }
    }, t.getCookie = function (e, t) {
        var n = [];
        try {
            n = e.cookie ? e.cookie.split("; ") : []
        } catch (e) {
        }
        for (var r, o = /(%[0-9A-Z]{2})+/g, i = 0; i < n.length; i++) {
            var a = n[i].split("="), c = a.slice(1).join("=");
            try {
                var s = a[0].replace(o, decodeURIComponent);
                if (c.replace(o, decodeURIComponent), t === s) {
                    r = decodeURIComponent(c);
                    break
                }
            } catch (e) {
                return
            }
        }
        return r
    }, t.deleteCookie = function (e, n, o) {
        t.setCookie(e, n, "", r(r({}, o), {expires: new Date(0)}))
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.removeNodeFromParent = function (e) {
        if (e) {
            var t = e.parentElement;
            t && t.removeChild(e)
        }
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.getHasObjectDefineProperty = function (e) {
        void 0 === e && (e = window);
        var t = e.Object;
        try {
            var n = {};
            return t.defineProperty(n, "sentinel", {}), "sentinel" in n
        } catch (e) {
            return !1
        }
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0;
    var r = "__longExperiment", o = location.host, i = n(53).filter(n(94).ignoreHosts, function (e) {
            return e.test(o)
        }).length > 0,
        a = n(54).some([/^\w+:\/\/[^?\/]*avito/, /^\w+:\/\/[^?\/]*brozen[-\w]*\.yandex\.ru/, /^\w+:\/\/[^?\/]*yandex[.\w]+\/(pogoda|weather|hava)/, /^\w+:\/\/[^?\/]*netbynet\.wi-fi\.ru/], function (e) {
            return e.test(location.href)
        }), c = [[{
            id: n(1).experimentIds.ssSkipToken.ENABLED,
            percent: a ? 96 : 0
        }, {id: n(1).experimentIds.ssSkipToken.WIDE_LOG, percent: 1}, {
            id: n(1).experimentIds.ssSkipToken.CLIENT,
            percent: 1
        }, {id: n(1).experimentIds.ssSkipToken.SERVER_MANUAL, percent: 1}, {
            id: n(1).experimentIds.ssSkipToken.SERVER_AUTO,
            percent: 1
        }], [{id: n(1).experimentIds.priceInText.ENABLED, percent: 50}, {
            id: n(1).experimentIds.priceInText.DISABLED,
            percent: 50
        }], [{id: n(1).experimentIds.geoSkin.V1, percent: 33}, {
            id: n(1).experimentIds.geoSkin.V2,
            percent: 33
        }, {id: n(1).experimentIds.geoSkin.V3, percent: 33}, {
            id: n(1).experimentIds.geoSkin.DISABLED,
            percent: 1
        }], [{id: n(1).experimentIds.smartCrop.ALLOWED, percent: 96}, {
            id: n(1).experimentIds.smartCrop.DISABLED,
            percent: 2
        }, {id: n(1).experimentIds.smartCrop.ENABLED, percent: 2}], [{
            id: n(1).experimentIds.similarButton.ENABLED,
            percent: 100
        }], [{id: n(1).experimentIds.sendBeaconExp.XHR, percent: 0}, {
            id: n(1).experimentIds.sendBeaconExp.SENDBEACON,
            percent: 0
        }, {id: n(1).experimentIds.sendBeaconExp.CONTROL, percent: 0}, {
            id: n(1).experimentIds.sendBeaconExp.DISABLED,
            percent: 100
        }], [{
            id: n(1).experimentIds.motionBigTitle.ENABLED_NORMAL,
            percent: 100
        }], [{id: n(1).experimentIds.clickDelayWiFi.ENABLED, percent: 50}, {
            id: n(1).experimentIds.clickDelayWiFi.DISABLED,
            percent: 50
        }]];
    t.initLongExperiment = function () {
        var e = new (n(95).LongExperiment)(c);
        n(0).setGlobalVariable(r, e)
    }, t.isLongExperiment = function (e) {
        if (i) return !1;
        var t = n(0).getGlobalVariable(r);
        return !!t && t.isCurrentVersion(e)
    }
}, function (e, t, n) {
    "use strict";
    var r = function () {
        return (r = Object.assign || function (e) {
            for (var t, n = 1, r = arguments.length; n < r; n++) for (var o in t = arguments[n]) Object.prototype.hasOwnProperty.call(t, o) && (e[o] = t[o]);
            return e
        }).apply(this, arguments)
    };
    t.__esModule = !0;
    var o = function () {
        function e(e, t, o, i) {
            this.service = e, this.version = t, this.sid = o, this.labels = r({
                device: n(65).isTouchDevice ? "mobile" : "desktop",
                version: t
            }, i), this.data = {}
        }

        return e.prototype.config = function (e) {
            this.labels = r(r({}, this.labels), e.labels), this.data = r(r({}, this.data), e.data)
        }, e.prototype.log = function (e, t) {
            var o;
            if (void 0 === t && (t = 25), n(3).isPercent(t)) {
                var i = [];
                e.type && i.push(e.type), e.namespace && i.push(e.namespace), e.error && e.error.name && i.push(e.error.name);
                var a = i.join("_");
                n(21).request(this.getRequestObject({
                    eventType: n(14).StatsEventType.error,
                    eventName: a,
                    data: r(r(r({}, this.data), e.error), {
                        bundle: "default",
                        code: e.namespace,
                        type: e.type,
                        href: window.location.href
                    }),
                    tags: (o = {}, o[n(14).StatsEventType.error + "_" + a] = 1, o)
                }))
            }
        }, e.prototype.logData = function (e, t) {
            var o;
            if (void 0 === t && (t = 1), n(3).isPercent(t)) {
                var i = [];
                e.type && i.push(e.type), e.name && i.push(e.name), e.data && e.data.name && i.push(e.data.name);
                var a = i.join("_");
                n(21).request(this.getRequestObject({
                    eventType: n(14).StatsEventType.event,
                    eventName: a,
                    data: r(r({}, this.data), e.data),
                    tags: (o = {}, o[n(14).StatsEventType.event + "_" + a] = 1, o)
                }))
            }
        }, e.prototype.logPlain = function (e, t) {
            void 0 === t && (t = 100), n(3).isPercent(t) && n(21).request(this.getRequestObject(e))
        }, e.prototype.getDefaultFields = function () {
            return {
                service: this.service,
                version: this.version,
                sid: this.sid,
                labels: this.labels,
                data: this.data,
                timestamp: Number(new Date),
                userAgent: navigator.userAgent,
                referrer: document.referrer,
                location: n(50).getHref()
            }
        }, e.prototype.getRequestObject = function (e) {
            return {
                method: "POST",
                url: n(118).PCODE_LOGS_URL,
                data: JSON.stringify(r(r({}, this.getDefaultFields()), e)),
                onBeforeSend: void 0
            }
        }, e
    }();
    t.JSTracerLoggerSlim = o
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.isTouchDevice = n(111).isTouchDevice()
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.getIsEdge = function (e) {
        return void 0 === e && (e = window), n(67).getInternetExplorerVersion(e) > 11
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.getInternetExplorerVersion = function (e) {
        void 0 === e && (e = window);
        var t = n(113)(e);
        return "boolean" == typeof t ? -1 : t
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.getWindowDataSource = function (e, t, r) {
        var o = n(24).get(e, t);
        return o || (o = r(), n(25).set(e, t, o)), o
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.loadCustomScript = function (e) {
        var t = e.win.document.createElement("script");
        return t.async = !0, e.nonce && (t.nonce = e.nonce), n(8).isFunction(e.onLoad) && (t.onload = function () {
            t.onload = function () {
            }, n(8).isFunction(e.onLoad) && e.onLoad()
        }), e.hasCors = "boolean" != typeof e.hasCors || e.hasCors, e.hasCors && t.setAttribute("crossorigin", "anonymous"), t.src = e.src, e.container ? e.container.appendChild(t) : n(36).getHead(e.win).appendChild(t), t
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.generateHexString = function (e) {
        for (var t = "", r = 0; r < e; r++) t += (16 * n(37).random() | 0).toString(16);
        return t
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.products = {
        Direct: "D",
        Internal: "I",
        Inpage: "VI",
        Fullscreen: "VF",
        Premium: "P",
        Stripe: "S",
        Distribution: "Y",
        Rtb: "R"
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.isRtbInDirectExperiment = function (e) {
        e.pageId;
        var t = e.product;
        return !e.hasSearchText && n(132).isDirect(t)
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0;
    !function () {
        window.Promise || (window.Promise = n(74)), n(78).initYaVariable(), n(80).initYaVersion(), n(93).initCallbacks(), n(63).initLongExperiment(), n(96).initAsyncRtb(), n(97).initSyncRtb(), n(98).initSyncDirect(), n(99).loadContextStatic();
        var e = n(0).getYaContext();
        n(11).getIsCompatibilityMode() ? Boolean(e._init) && e._init() : (e.AdvManager || (n(0).setGlobalVariable("isNewLoader", !0), e.AdvManager = new (n(130).AdvManagerLoader)), e.processCallbacks())
    }()
}, function (e, t, n) {
    (function (t) {
        !function (n, r) {
            function o(e, t) {
                return (typeof t)[0] == e
            }

            function i(e, t) {
                return (t = function c(s, u, l, d, f, p) {
                    if (d = c.q, s != o) return i(function (e, t) {
                        d.push({p: this, r: e, j: t, 1: s, 0: u})
                    });
                    if (l && o(n, l) | o(r, l)) try {
                        f = l.then
                    } catch (e) {
                        u = 0, l = e
                    }
                    if (o(n, f)) try {
                        f.call(l, _(1), u = _(0))
                    } catch (e) {
                        u(e)
                    } else for (t = function (t, r) {
                        return o(n, t = u ? t : r) ? i(function (e, n) {
                            a(this, e, n, l, t)
                        }) : e
                    }, p = 0; p < d.length;) f = d[p++], o(n, s = f[u]) ? a(f.p, f.r, f.j, l, s) : (u ? f.r : f.j)(l);

                    function _(e) {
                        return function (t) {
                            f && (f = 0, c(o, e, t))
                        }
                    }
                }).q = [], e.call(e = {
                    then: function (e, n) {
                        return t(e, n)
                    }, catch: function (e) {
                        return t(0, e)
                    }
                }, function (e) {
                    t(o, 1, e)
                }, function (e) {
                    t(o, 0, e)
                }), e
            }

            function a(e, i, a, c, s) {
                t(function () {
                    try {
                        c = s(c), s = c && o(r, c) | o(n, c) && c.then, o(n, s) ? c == e ? a(TypeError()) : s.call(c, i, a) : i(c)
                    } catch (e) {
                        a(e)
                    }
                })
            }

            function c(e) {
                return i(function (t) {
                    t(e)
                })
            }

            e.exports = i, i.resolve = c, i.reject = function (e) {
                return i(function (t, n) {
                    n(e)
                })
            }, i.all = function (e) {
                return i(function (t, n, r, o) {
                    o = [], r = e.length || t(o), e.map(function (e, i) {
                        c(e).then(function (e) {
                            o[i] = e, --r || t(o)
                        }, n)
                    })
                })
            }, i.race = function (e) {
                return i(function (t, n) {
                    e.map(function (e) {
                        c(e).then(t, n)
                    })
                })
            }
        }("f", "o")
    }).call(t, n(75).setImmediate)
}, function (e, t, n) {
    (function (e) {
        var r = void 0 !== e && e || "undefined" != typeof self && self || window, o = Function.prototype.apply;

        function i(e, t) {
            this._id = e, this._clearFn = t
        }

        t.setTimeout = function () {
            return new i(o.call(setTimeout, r, arguments), clearTimeout)
        }, t.setInterval = function () {
            return new i(o.call(setInterval, r, arguments), clearInterval)
        }, t.clearTimeout = t.clearInterval = function (e) {
            e && e.close()
        }, i.prototype.unref = i.prototype.ref = function () {
        }, i.prototype.close = function () {
            this._clearFn.call(r, this._id)
        }, t.enroll = function (e, t) {
            clearTimeout(e._idleTimeoutId), e._idleTimeout = t
        }, t.unenroll = function (e) {
            clearTimeout(e._idleTimeoutId), e._idleTimeout = -1
        }, t._unrefActive = t.active = function (e) {
            clearTimeout(e._idleTimeoutId);
            var t = e._idleTimeout;
            t >= 0 && (e._idleTimeoutId = setTimeout(function () {
                e._onTimeout && e._onTimeout()
            }, t))
        }, n(76), t.setImmediate = "undefined" != typeof self && self.setImmediate || void 0 !== e && e.setImmediate || this && this.setImmediate, t.clearImmediate = "undefined" != typeof self && self.clearImmediate || void 0 !== e && e.clearImmediate || this && this.clearImmediate
    }).call(t, n(38))
}, function (e, t, n) {
    (function (e, t) {
        !function (e, n) {
            "use strict";
            if (!e.setImmediate) {
                var r, o, i, a, c, s = 1, u = {}, l = !1, d = e.document,
                    f = Object.getPrototypeOf && Object.getPrototypeOf(e);
                f = f && f.setTimeout ? f : e, "[object process]" === {}.toString.call(e.process) ? r = function (e) {
                    t.nextTick(function () {
                        _(e)
                    })
                } : !function () {
                    if (e.postMessage && !e.importScripts) {
                        var t = !0, n = e.onmessage;
                        return e.onmessage = function () {
                            t = !1
                        }, e.postMessage("", "*"), e.onmessage = n, t
                    }
                }() ? e.MessageChannel ? ((i = new MessageChannel).port1.onmessage = function (e) {
                    _(e.data)
                }, r = function (e) {
                    i.port2.postMessage(e)
                }) : d && "onreadystatechange" in d.createElement("script") ? (o = d.documentElement, r = function (e) {
                    var t = d.createElement("script");
                    t.onreadystatechange = function () {
                        _(e), t.onreadystatechange = null, o.removeChild(t), t = null
                    }, o.appendChild(t)
                }) : r = function (e) {
                    setTimeout(_, 0, e)
                } : (a = "setImmediate$" + Math.random() + "$", c = function (t) {
                    t.source === e && "string" == typeof t.data && 0 === t.data.indexOf(a) && _(+t.data.slice(a.length))
                }, e.addEventListener ? e.addEventListener("message", c, !1) : e.attachEvent("onmessage", c), r = function (t) {
                    e.postMessage(a + t, "*")
                }), f.setImmediate = function (e) {
                    "function" != typeof e && (e = new Function("" + e));
                    for (var t = new Array(arguments.length - 1), n = 0; n < t.length; n++) t[n] = arguments[n + 1];
                    var o = {callback: e, args: t};
                    return u[s] = o, r(s), s++
                }, f.clearImmediate = p
            }

            function p(e) {
                delete u[e]
            }

            function _(e) {
                if (l) setTimeout(_, 0, e); else {
                    var t = u[e];
                    if (t) {
                        l = !0;
                        try {
                            !function (e) {
                                var t = e.callback, r = e.args;
                                switch (r.length) {
                                    case 0:
                                        t();
                                        break;
                                    case 1:
                                        t(r[0]);
                                        break;
                                    case 2:
                                        t(r[0], r[1]);
                                        break;
                                    case 3:
                                        t(r[0], r[1], r[2]);
                                        break;
                                    default:
                                        t.apply(n, r)
                                }
                            }(t)
                        } finally {
                            p(e), l = !1
                        }
                    }
                }
            }
        }("undefined" == typeof self ? void 0 === e ? this : e : self)
    }).call(t, n(38), n(77))
}, function (e, t) {
    var n, r, o = e.exports = {};

    function i() {
        throw new Error("setTimeout has not been defined")
    }

    function a() {
        throw new Error("clearTimeout has not been defined")
    }

    function c(e) {
        if (n === setTimeout) return setTimeout(e, 0);
        if ((n === i || !n) && setTimeout) return n = setTimeout, setTimeout(e, 0);
        try {
            return n(e, 0)
        } catch (t) {
            try {
                return n.call(null, e, 0)
            } catch (t) {
                return n.call(this, e, 0)
            }
        }
    }

    !function () {
        try {
            n = "function" == typeof setTimeout ? setTimeout : i
        } catch (e) {
            n = i
        }
        try {
            r = "function" == typeof clearTimeout ? clearTimeout : a
        } catch (e) {
            r = a
        }
    }();
    var s, u = [], l = !1, d = -1;

    function f() {
        l && s && (l = !1, s.length ? u = s.concat(u) : d = -1, u.length && p())
    }

    function p() {
        if (!l) {
            var e = c(f);
            l = !0;
            for (var t = u.length; t;) {
                for (s = u, u = []; ++d < t;) s && s[d].run();
                d = -1, t = u.length
            }
            s = null, l = !1, function (e) {
                if (r === clearTimeout) return clearTimeout(e);
                if ((r === a || !r) && clearTimeout) return r = clearTimeout, clearTimeout(e);
                try {
                    r(e)
                } catch (t) {
                    try {
                        return r.call(null, e)
                    } catch (t) {
                        return r.call(this, e)
                    }
                }
            }(e)
        }
    }

    function _(e, t) {
        this.fun = e, this.array = t
    }

    function m() {
    }

    o.nextTick = function (e) {
        var t = new Array(arguments.length - 1);
        if (arguments.length > 1) for (var n = 1; n < arguments.length; n++) t[n - 1] = arguments[n];
        u.push(new _(e, t)), 1 !== u.length || l || c(p)
    }, _.prototype.run = function () {
        this.fun.apply(null, this.array)
    }, o.title = "browser", o.browser = !0, o.env = {}, o.argv = [], o.version = "", o.versions = {}, o.on = m, o.addListener = m, o.once = m, o.off = m, o.removeListener = m, o.removeAllListeners = m, o.emit = m, o.prependListener = m, o.prependOnceListener = m, o.listeners = function (e) {
        return []
    }, o.binding = function (e) {
        throw new Error("process.binding is not supported")
    }, o.cwd = function () {
        return "/"
    }, o.chdir = function (e) {
        throw new Error("process.chdir is not supported")
    }, o.umask = function () {
        return 0
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.initYaVariable = function () {
        var e = n(0).getYa();
        e.Context || (e.Context = n(0).initYaContext()), e.Direct || (e.Direct = n(0).initYaDirect())
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0;
    var r = {21753: 50, 27219: 50, 101833: 50, 122989: 50, 70350: 50, 250894: 10};
    t.isAllowedRepeatAds = function (e, t) {
        if (e in r) {
            var o = r[e];
            return "boolean" == typeof o ? o : r[e] = n(3).isPercent(o)
        }
        return t
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.initYaVersion = function () {
        var e, t = (e = n(81), n(31).isHomePage(window) && (e.code = [{
            id: 8450,
            percent: 100,
            extra: {match: 8450, confirm: "//st.yandexadexchange.net/confirm_r_8450.html"}
        }]), e), r = n(0).getYa(), o = n(22).getCrossFrameStorage("pcode"), i = o.getItem("versionInfo");
        if (r.codeVer = i && i.codeVer, void 0 === r.codeVer) {
            r.loaderVer = t.loader;
            var a = new (n(84).UserGroupExperiment)(t.code), c = n(13).urlCodeVersions.pcode;
            5428 === c && (c = 5699);
            var s = window.location.hostname;
            /^(([a-z0-9-]+\.)?)+devmail\.ru$/i.test(s) && (c = a.getDefaultId()), c ? r.codeVer = c : (r.codeVer = a.getId(), n(43).isLegacyBrowser && (r.codeVer = 9636)), r._exp = a, o.setItem("versionInfo", {
                codeVer: r.codeVer,
                loaderVer: r.loaderVer,
                relHostname: r.relHostname,
                exp: r._exp
            })
        } else r.codeVer = i.codeVer, r.loaderVer = i.loaderVer, r._exp = i.exp, r.relHostname = i.relHostname
    }
}, function (e, t) {
    e.exports = {
        loader: 1579856606232,
        stable: 10157,
        code: [{id: 10195, percent: 10}, {id: 10200, percent: 10}, {id: 10201, percent: 10}, {
            id: 10202,
            percent: 10
        }, {id: 10203, percent: 10}, {id: 10188, percent: 5}, {id: 10186, percent: 5}, {id: 10157, percent: 40}]
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.getCrossFrameDataSource = function (e, t, r) {
        var o;
        return n(83).traverseBreadth([e.top], function (e) {
            if (!(o = n(5).callSafe(function () {
                return n(24).get(e, t)
            }))) return n(5).callSafe(function () {
                return n(57).listToArray(e.frames)
            }) || []
        }), o || (o = r()), n(25).set(e, t, o), o
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.traverseBreadth = function (e, t) {
        for (var n = e.slice(); n.length;) {
            var r = t(n.shift());
            if (!r) return;
            n.push.apply(n, r)
        }
    }
}, function (e, t, n) {
    "use strict";
    var r, o, i = (r = function (e, t) {
        return (r = Object.setPrototypeOf || {__proto__: []} instanceof Array && function (e, t) {
            e.__proto__ = t
        } || function (e, t) {
            for (var n in t) t.hasOwnProperty(n) && (e[n] = t[n])
        })(e, t)
    }, function (e, t) {
        function n() {
            this.constructor = e
        }

        r(e, t), e.prototype = null === t ? Object.create(t) : (n.prototype = t.prototype, new n)
    });
    t.__esModule = !0, function (e) {
        e[e["Server"] = 0] = "Server", e[e["Cookie"] = 1] = "Cookie", e[e["Random"] = 2] = "Random"
    }(o = t.CoinType || (t.CoinType = {}));
    var a = function (e) {
        function t() {
            return null !== e && e.apply(this, arguments) || this
        }

        return i(t, e), t.getSalt = function () {
            var e = new Date, t = e.getFullYear() + "-" + e.getMonth() + "-" + e.getDate();
            return n(40).murmurhash(t)
        }, t.prototype.flipCoin = function () {
            this.coinType = o.Random, this.userGroupCoin = Math.random();
            var e = n(60).getCookie(document, "yandexuid");
            if (Boolean(e)) {
                var r = n(3).toFraction(n(40).murmurhash(e || "", t.getSalt()) % 100);
                this.coinType = o.Cookie, this.userGroupCoin = r
            }
            var i = n(86).getUserGroup(4);
            if (!isNaN(i)) {
                var a = n(3).toFraction(i);
                this.coinType = o.Server, this.userGroupCoin = a
            }
            return this.userGroupCoin
        }, t.prototype.getUserGroupCoin = function () {
            return {coin: this.userGroupCoin, type: this.coinType}
        }, t
    }(n(41).Experiment);
    t.UserGroupExperiment = a
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.isDate = function (e) {
        return e instanceof Date || "Date" === n(23).getInternalClass(e)
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.SERVER_USER_GROUP = "3";
    var r = function () {
        return parseInt(t.SERVER_USER_GROUP, 10)
    }, o = 4;

    function i(e) {
        return Math.floor(Number(new Date) / 1e3 / 3600 * (1 / e)) % 100 || 0
    }

    t.getUserGroup = function (e) {
        return void 0 === e && (e = o), (r() + i(e)) % 100
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0;
    var r = n(51).getNativeMethod(Array, "isArray");
    t.isArray = Boolean(r) ? function (e) {
        return r.call(Array, e)
    } : function (e) {
        return "Array" === n(23).getInternalClass(e)
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.createHiddenFriendlyIFrame = function (e) {
        var t = n(89).createFriendlyIFrame(e);
        return t.width = "0", t.height = "0", t.style.position = "absolute", t
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.createFriendlyIFrame = function (e) {
        var t = e.ownerDocument.createElement("iframe");
        t.scrolling = "no", t.setAttribute("allowfullscreen", ""), t.style.display = "block", e.appendChild(t);
        var n = t.contentDocument;
        return n.open(), n.close(), n.body.style.margin = "0", t.style.borderWidth = "0", t
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.removeIframe = function (e) {
        e.src = "", n(61).removeNodeFromParent(e)
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.testProperty = function (e, t) {
        if (void 0 === t && (t = n(26).cssPrefixes), !e) return !1;
        var r = e.split(":"), o = r[0], i = r[1];
        if (i || (i = "none"), window.CSS && window.CSS.supports) {
            for (var a = 0; a < t.length; a++) if (window.CSS.supports(t[a] + o, i)) return !0;
            return !1
        }
        var c = new Image;
        for (a = 0; a < t.length; a++) if (c.style.cssText = t[a] + o + ":" + i, c.style.length) return !0;
        return !1
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.hasObjectDefineProperty = n(62).getHasObjectDefineProperty()
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0;
    t.initCallbacks = function () {
        var e, t = n(11).getCallbacksArrayName();
        n(0).getYaContext().processCallbacks = n(5).protect("Ya.context." + t, (e = t, function () {
            for (var t = n(0).getYaContext(), r = 0; r < t[e].length; r++) n(5).protect("Ya.context." + e + "_call", t[e][r])();
            t[e] = []
        }))
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.ignoreHosts = [/mail\.ru/i, /devmail\.ru/i]
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0;
    var r = function () {
        function e(e) {
            this.experiments = [];
            for (var t = 0; t < e.length; t++) this.experiments.push(new (n(41).Experiment)(e[t]))
        }

        return e.prototype.isCurrentVersion = function (e) {
            for (var t = 0; t < this.experiments.length; t++) if (this.experiments[t].getId() === e) return !0;
            return !1
        }, e
    }();
    t.LongExperiment = r
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0;
    var r = ["yandex_context_callbacks", "yandexContextAsyncCallbacks"];
    t.initAsyncRtb = function (e) {
        void 0 === e && (e = window);
        for (var t = 0; t < r.length; t++) {
            var o = n(12).extractProp(r[t]);
            if (o) {
                var i = n(0).getYaContext();
                i._asyncModeOn || (i._asyncModeOn = !0);
                for (var a = n(11).getCallbacksArray(), c = 0; c < o.length; c++) a.push(o[c])
            }
        }
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.initSyncRtb = function (e) {
        if (void 0 === e && (e = window), e.yandexContextSyncCallbacks) for (var t = n(12).extractProp("yandexContextSyncCallbacks"), r = n(11).getCallbacksArray(), o = 0; o < t.length; o++) r.push(t[o])
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.initSyncDirect = function (e) {
        if (void 0 === e && (e = window), e.yandex_ad_format) {
            var t = {};
            n(12).extractSettings(t, r), n(12).extractSettings(t, o, t.ad_format);
            var i = n(0).getYaContext(), a = t.place;
            a && document.getElementById(a) || (a = "Ya_sync_" + i._asyncIdCounter++, document.write('<div id="' + a + '"></div>'));
            var c = n(11).getCallbacksArray(), s = n(12).extractPrefixedProp("partner_id");
            c.push(function () {
                i.AdvManager.renderDirect(s, a, t)
            })
        }
    };
    var r = ["ad_format", "site_bg_color", "font_size", "font_family", "stat_id", "no_sitelinks", "search_text", "search_page_number", "lang"],
        o = ["type", "border_type", "bg_color", "border_radius", "border_color", "header_bg_color", "title_color", "text_color", "url_color", "hover_color", "sitelinks_color", "links_underline", "limit", "place", "favicon", "title_font_size", "grab", "c11n", "geo_lat", "geo_long", "width", "height"]
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0;
    var r = !1;
    t.loadContextStatic = function () {
        var e = document.currentScript && document.currentScript.src || "",
            t = n(100).getBundleUrl(window, n(0).getYa(), e);
        if (!document.getElementById(t) && !r) {
            0;
            var o = n(0).getYaContext();
            if (o._asyncModeOn || (document.write('<script type="text/javascript" src="' + t + '" id="' + t + '"><\/script>'), document.getElementById(t) || (o._asyncModeOn = !0)), o._asyncModeOn) {
                var i = n(36).getHead(window);
                try {
                    var a = document.createElement("link");
                    a.rel = "preload", a.href = t, a.as = "script", i.appendChild(a)
                } catch (e) {
                    n(10).logger.error(e, "PreloadStatic")
                }
                var c = document.createElement("script");
                c.id = t, c.src = t, i.appendChild(c)
            }
        }
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.getBundleUrl = function (e, t, r) {
        return "https:" + (r.indexOf("/yastatic.net/") > -1 ? "//yastatic.net/partner-code-bundles/" : "//an.yandex.ru/partner-code-bundles/") + String(t.codeVer) + "/" + function (e) {
            return n(43).isLegacyBrowser ? "context_static.js" : n(101).isMailRuMailPage(e) ? "context_static_mailru_mail.js" : n(102).isMailRuOkPage(e) ? "context_static_mailru_ok.js" : n(103).isNewsPage(e) ? "context_static_news.js" : n(44).isSspPage(e) ? "context_static_ssp.js" : n(104).isRamblerPage(e) ? "context_static_rambler_main.js" : n(55).isTurboPage(e) ? "context_static_turbo.js" : n(31).isHomePage(e) ? "context_static_home.js" : n(105).isImagesPage(e) ? "context_static_images.js" : n(106).isAvitoDesktopPage(e) ? "context_static_avito_desktop.js" : n(107).isRamblerMobilePage(e) || n(108).isAvitoMobilePage(e) || n(109).isYandexGamesPage(e) ? "context_static_top_mobile.js" : "context_static.js"
        }(e)
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.isMailRuMailPage = function (e) {
        return void 0 === e && (e = window), Boolean(e.YA_MAILRU_MAIL)
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.isMailRuOkPage = function (e) {
        return void 0 === e && (e = window), Boolean(e.YA_MAILRU_OK)
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.isNewsPage = function (e) {
        return n(7).isObject(e.Ya) && Boolean(e.Ya.news)
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.isRamblerPage = function (e) {
        return void 0 === e && (e = window), Boolean(e.YA_RAMBLER_MAIN)
    }
}, function (e, t, n) {
    "use strict";
    var r = "function" == typeof Symbol && "symbol" == typeof Symbol.iterator ? function (e) {
        return typeof e
    } : function (e) {
        return e && "function" == typeof Symbol && e.constructor === Symbol && e !== Symbol.prototype ? "symbol" : typeof e
    };
    t.__esModule = !0, t.isImagesPage = function (e) {
        return -1 !== e.location.hostname.indexOf("yandex") && "object" === r(e.Ya.Images)
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.isAvitoDesktopPage = function (e) {
        return void 0 === e && (e = window), -1 !== e.location.hostname.indexOf("avito") && Boolean(e.avito_desktop)
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.isRamblerMobilePage = function (e) {
        return void 0 === e && (e = window), Boolean(e.YA_RAMBLER_MOBILE)
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.isAvitoMobilePage = function (e) {
        return void 0 === e && (e = window), -1 !== e.location.hostname.indexOf("avito") && Boolean(e.avito_mob_web)
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.isYandexGamesPage = function (e) {
        return void 0 === e && (e = window), Boolean(e.LightweightYaGamesAdsBundle)
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, function (e) {
        var t = new (n(64).JSTracerLoggerSlim)("pcode_errors", String(n(18).getCodeVersion()), n(19).getSessionId()),
            r = new (n(126).MetrikaLogger);

        function o(t) {
            e.debug("REMOTE_LOG:", t)
        }

        function i(e, t) {
            return function (r, i) {
                var a = function (e, t, r) {
                    return "string" == typeof t && (r = "remoteLogString", t = {message: t}), {
                        namespace: r,
                        version: n(18).getCodeVersion(),
                        type: e,
                        error: {name: t.name, message: t.message, stack: t.stack}
                    }
                }(e, r, i);
                n(13).pcodeDebugFlag ? (o(a), n(129).rethrowError(new Error(r))) : n(27).forEach(t, function (e) {
                    return e.log(a)
                })
            }
        }

        function a(e) {
            return function (r, i, a) {
                n(13).pcodeDebugFlag ? o(r) : ("string" == typeof r && (r = {msg: r}), t.logData({
                    type: e,
                    data: r,
                    name: i,
                    version: String(n(18).getCodeVersion())
                }, a))
            }
        }

        e.error = i("ERROR", [t, r]), e.warn = i("WARNING", [t, r]), e.log = a("IMPORTANT"), e.info = a("INFO"), e.debug = n(13).pcodeDebugFlag ? function () {
            for (var e = [], t = 0; t < arguments.length; t++) e[t] = arguments[t];
            return console.warn.apply(console, e)
        } : n(4).noop, e.configure = function (e) {
            t.config(e)
        }
    }(t.logger || (t.logger = {}))
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.isTouchDevice = function (e) {
        return void 0 === e && (e = window), n(112).hasTouchPoints(e) || n(114).isMatchingAnyPointerCoarse(e) || n(115).isMatchingTouchEnabled(e) || n(116).hasDocumentTouch(e) || n(117).hasTouchEvents(e)
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.hasTouchPoints = function (e) {
        return function (e) {
            return Boolean(e.PointerEvent)
        }(e) && function (e) {
            var t = e.navigator || {}, n = t.msMaxTouchPoints, r = t.maxTouchPoints;
            return n || r || 0
        }(e) > 0 && !n(66).getIsEdge(e)
    }
}, function (e, t) {
    e.exports = function (e) {
        e || (e = window);
        var t = e.navigator.userAgent, n = t.indexOf("MSIE ");
        if (n > 0) return parseInt(t.substring(n + 5, t.indexOf(".", n)), 10);
        if (t.indexOf("Trident/") > 0) {
            var r = t.indexOf("rv:");
            return parseInt(t.substring(r + 3, t.indexOf(".", r)), 10)
        }
        var o = t.indexOf("Edge/");
        return o > 0 && parseInt(t.substring(o + 5, t.indexOf(".", o)), 10)
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0;
    var r = n(30).map(n(26).cssPrefixes, function (e) {
        return "(" + e + "any-pointer:coarse)"
    }).join(",");
    t.isMatchingAnyPointerCoarse = function (e) {
        return n(45).isMatchingMediaQuery(e, r)
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.TOUCH_ENABLED_QUERY = n(30).map(n(26).cssPrefixes, function (e) {
        return "(" + e + "touch-enabled)"
    }).join(","), t.isMatchingTouchEnabled = function (e) {
        return n(45).isMatchingMediaQuery(e, t.TOUCH_ENABLED_QUERY)
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.hasDocumentTouch = function (e) {
        var t = e.DocumentTouch;
        return Boolean(t) && e.document instanceof t
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.hasTouchEvents = function (e) {
        return "ontouchstart" in e
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.PCODE_LOGS_URL = "https://an.yandex.ru/jstracer", t.PCODE_LOGS_URL_ALIAS = "https://jstracer.yandex.ru/jstracer", t.STRM_LOGS_URL = "https://strm.yandex.ru/log"
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.getSession = function (e, t, r, o) {
        var i = t.getItem(n(9).SESSION_KEY);
        return i || (i = r.getItem(n(9).SESSION_KEY) || e(), o(window, i)), t.setItem(n(9).SESSION_KEY, i), r.setItem(n(9).SESSION_KEY, i), i
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.generateSessionId = function () {
        return (1e6 * n(37).random()).toFixed(0) + (new Date).valueOf().toString()
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.IS_BROKEN_MATH_RANDOM = !n(16).checkNativeCode(Math.random) || Math.random() == Math.random()
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0;
    var r = 2147483647, o = 16807, i = Date.now() * n(123).performanceNow() % r;
    var a = r - 1;
    t.pseudoRandom = function () {
        return ((i = i * o % r) - 1) / a
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0;
    var r = "undefined" == typeof window ? void 0 : window.performance;
    t.isPerformanceNowSupported = r && n(8).isFunction(r.now);
    var o = r && r.timing && r.timing.navigationStart ? r.timing.navigationStart : n(46).dateNow();
    t.performanceNowShim = function () {
        return n(46).dateNow() - o
    }, t.performanceNow = t.isPerformanceNowSupported ? function () {
        return r.now()
    } : function () {
        return t.performanceNowShim()
    }
}, function (e, t, n) {
    "use strict";
    var r = function () {
        return (r = Object.assign || function (e) {
            for (var t, n = 1, r = arguments.length; n < r; n++) for (var o in t = arguments[n]) Object.prototype.hasOwnProperty.call(t, o) && (e[o] = t[o]);
            return e
        }).apply(this, arguments)
    };
    t.__esModule = !0;
    t.pushMetrikaEvent = n(5).protect("metrika::pushEvent", function (e, t) {
        var o = n(24).get(e, "Ya._metrika.dataLayer") || [];
        n(25).set(e, "Ya._metrika.dataLayer", o), o.push({
            ymetrikaEvent: {
                type: "params",
                parent: 1,
                data: {__ym: r({}, t)}
            }
        })
    })
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.setSession = function (e, t, r, o) {
        o(window, e), t.setItem(n(9).SESSION_KEY, e), r.setItem(n(9).SESSION_KEY, e)
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0;
    var r = 1, o = function () {
        function e(e) {
            void 0 === e && (e = r), this.threshold = e
        }

        return e.prototype.log = function (e) {
            var t = {};
            if (t[e.version] = {}, t[e.version][e.namespace] = {}, t[e.version][e.namespace][e.error.name] = e.error, n(3).isPercent(this.threshold)) {
                n(127).requestCounter({id: 42093449, enableCookies: !1}, function (e) {
                    e.hit(window.location.href, {params: t})
                })
            }
        }, e
    }();
    t.MetrikaLogger = o
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0;
    var r = !n(6).checkBundleType(n(6).bundleTypes.SSP) && !n(6).checkBundleType(n(6).bundleTypes.mobileSdk) && !0,
        o = n(128).MetrikaManager.getInstance(function () {
            return n(0).getYa()
        }, r);
    t.requestCounter = function (e, t) {
        o.requestCounter(e, t)
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.metrikaCallbacksDict = {
        Metrika: "yandex_metrika_callbacks",
        Metrika2: "yandex_metrika_callbacks2"
    };
    t.METRIKA_URL = "https://mc.yandex.ru/metrika/watch.js";
    var r = "https://d93ih7uy3azjp.cloudfront.net/metrika/watch.js", o = function () {
        function e(e, o, i) {
            var a = this;
            this.getYa = e, this.needLoadMetrika = o, this.loadMetrika = n(20).once(function () {
                if (a.needLoadMetrika && !a.win.YA_TURBO_METRIKA) {
                    var e = a.getYa().relHostname ? r : t.METRIKA_URL;
                    n(69).loadCustomScript({src: e, win: a.win})
                }
            }), this.win = i || window, Boolean(e().Metrika) ? this.metrikaName = "Metrika" : Boolean(e().Metrika2) ? this.metrikaName = "Metrika2" : this.metrikaName = "tag" === this.win.YA_TURBO_METRIKA ? "Metrika2" : "Metrika", this.metrikaCallbacksName = t.metrikaCallbacksDict[this.metrikaName]
        }

        return e.getInstance = function (t, n) {
            return void 0 === n && (n = !0), this.instance || (this.instance = new e(t, n)), this.instance
        }, e.prototype.requestCounter = function (e, t) {
            var n = this;
            this.isLoaded() ? t(this.getCounter(e)) : (this.loadMetrika(), this.addCallback(function () {
                t(n.getCounter(e))
            }))
        }, e.prototype.getCounter = function (e) {
            var t = "yaCounter" + e.id;
            return this.win[t] || (this.win[t] = this.createCounter(e)), this.win[t]
        }, e.prototype.isLoaded = function () {
            return Boolean(this.getYa()[this.metrikaName])
        }, e.prototype.addCallback = function (e) {
            this.win[this.metrikaCallbacksName] || (this.win[this.metrikaCallbacksName] = []), this.win[this.metrikaCallbacksName].push(e)
        }, e.prototype.createCounter = function (e) {
            var t = this.getYa()[this.metrikaName];
            if (!t) throw new Error("metrika counter creation error: " + this.metrikaName + " is not in context");
            try {
                return new t({id: e.id, type: e.isYAN ? 1 : void 0, defer: !0, nck: !e.enableCookies})
            } catch (e) {
                throw new Error("metrika counter creation error: " + e.message)
            }
        }, e
    }();
    t.MetrikaManager = o
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.rethrowError = function (e) {
        setTimeout(function () {
            throw e
        }, 0)
    }
}, function (e, t, n) {
    "use strict";
    var r = function () {
        return (r = Object.assign || function (e) {
            for (var t, n = 1, r = arguments.length; n < r; n++) for (var o in t = arguments[n]) Object.prototype.hasOwnProperty.call(t, o) && (e[o] = t[o]);
            return e
        }).apply(this, arguments)
    };
    t.__esModule = !0;
    var o = n(131);
    o(n(4).noop);
    var i = {}, a = function (e, t) {
        var r = Number(new Date), a = n(28).parseBlockId(e.blockId || ""), c = e.blockId + "#" + (e.pageNumber || "");
        a.product === n(71).products.Direct && n(29).isFakeImpId(a.impId || "") && (c += "#" + e.renderTo), c in i ? (i[c].setConfig(e, r), t(i[c])) : o(function (n) {
            var o = n.RtbDataLoader;
            c in i || (i[c] = new o), i[c].setConfig(e, r), t(i[c])
        })
    }, c = n(0).getYaContext(), s = function () {
        function e() {
        }

        return e.asyncCall = function (e) {
            c.AdvManagerStatic ? e(c.AdvManagerStatic) : c._callbacks.push(function () {
                var t = n(0).getYaContext().AdvManagerStatic;
                t ? e(t) : n(10).logger.error(new Error("advManagerStatic is missing"), "NoAMS_asyncCall")
            })
        }, e.syncCall = function (e) {
            if (c.AdvManagerStatic) return e(c.AdvManagerStatic)
        }, e.prototype.render = function (t, o) {
            t.uniqueId || ((t = r({}, t)).uniqueId = n(70).generateHexString(10), t.slotIndex = n(133).increaseCounter()), n(49).setMark(t.uniqueId, n(49).RenderMarks.AdvManagerLoader), t.adSessionId && n(19).setSessionId(t.adSessionId), n(6).saveBundleType(t.bundle), n(6).saveBundleType(t.data);
            var i = function (t) {
                return e.asyncCall(function (e) {
                    return e.render(r({}, t), o)
                })
            }, c = n(28).parseBlockId(t.blockId || ""), s = c.product, u = c.pageId, l = c.impId;
            n(10).logger.configure({labels: {pageId: "loader"}, data: {pageId: u}});
            var d = n(35).getVersion(), f = 7887 === d || 7888 === d;
            if (n(56).getElementById(t.renderTo)) switch (s) {
                case"D":
                    if (n(72).isRtbInDirectExperiment({
                        pageId: u || "",
                        product: s,
                        hasSearchText: Boolean(t.searchText)
                    }) || n(29).isFakeImpId(l || "")) {
                        a(t, function (e) {
                            return f ? i(t) : e.loadData(i)
                        });
                        break
                    }
                case"I":
                case"VI":
                case"VF":
                case"P":
                case"S":
                case"Y":
                    i(t);
                    break;
                case"R":
                    a(t, function (e) {
                        return f ? i(t) : e.loadData(i)
                    });
                    break;
                default:
                    n(10).logger.warn(new Error("Unknown block type. blockId: " + t.blockId), "advmanagerloader.UnknownBlockType")
            } else n(10).logger.warn(new Error("No element with id #" + t.renderTo + " (" + u + ")(" + t.blockId + ")"), "advmanagerloader.render")
        }, e.prototype.renderDirect = function (t, n, r, o) {
            e.asyncCall(function (e) {
                return e.renderDirect(t, n, r, o)
            })
        }, e.prototype.renderOverlay = function (t, n) {
            e.asyncCall(function (e) {
                return e.renderOverlay(t, n)
            })
        }, e.prototype.getBid = function (t, n, r) {
            e.asyncCall(function (e) {
                return e.getBid(t, n, r)
            })
        }, e.prototype.releaseBid = function (t, n, r) {
            e.asyncCall(function (e) {
                return e.releaseBid(t, n, r)
            })
        }, e.prototype.getSkipToken = function (t) {
            return e.syncCall(function (e) {
                return e.getSkipToken(t)
            }) || ""
        }, e.prototype.getCapturedCount = function () {
            return e.syncCall(function (e) {
                return e.getCapturedCount()
            }) || 0
        }, e.prototype.getSkipBanner = function (t) {
            return e.syncCall(function (e) {
                return e.getSkipBanner(t)
            }) || ""
        }, e.prototype.getAdSessionId = function () {
            return n(19).getSessionId()
        }, e.prototype.destroy = function (t) {
            return e.syncCall(function (e) {
                return e.destroy(t)
            })
        }, e
    }();
    t.AdvManagerLoader = s
}, function (e, t, n) {
    e.exports = function (e, t) {
        n.e(0).then(function () {
            e(n(134))
        }.bind(undefined, n)).catch(function () {
            t && t.apply(this, arguments)
        })
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0, t.isDirect = function (e) {
        return "D" === e || "direct" === e
    }
}, function (e, t, n) {
    "use strict";
    t.__esModule = !0;
    var r = "slotCounter";

    function o() {
        var e = n(0).getGlobalVariable(r);
        return void 0 === e ? (n(0).setGlobalVariable(r, 0), 0) : e
    }

    t.getCounter = o, t.increaseCounter = function () {
        var e = o() + 1;
        return n(0).setGlobalVariable(r, e), e
    }
}]);