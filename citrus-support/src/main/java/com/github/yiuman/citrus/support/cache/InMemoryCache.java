package com.github.yiuman.citrus.support.cache;

import com.github.yiuman.citrus.support.utils.ThreadUtils;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicReference;
import java.util.function.Consumer;

/**
 * 内存缓存
 *
 * @param <K> 键值对键类型
 * @param <V> 键值对值类型
 * @author yiuman
 * @date 2020/4/6
 */
public class InMemoryCache<K, V> extends MapCache<K, V> {

    private final String namespace;

    public static final String DEFAULT_NAMESPACE = "default";

    private static final Map<String, InMemoryCache<?, ?>> CACHE_MAP = new ConcurrentHashMap<>(256);

    static {
        addCache(new InMemoryCache<>(DEFAULT_NAMESPACE));
    }

    public InMemoryCache(String namespace) {
        this.namespace = namespace;
    }

    public static <K, V> void addCache(InMemoryCache<K, V> cache) {
        CACHE_MAP.put(cache.namespace, cache);
    }

    public static <K, V> InMemoryCache<K, V> get(String namespace) {
        return get(namespace, null, false);
    }

    public static <K, V> InMemoryCache<K, V> get(String namespace, Consumer<InMemoryCache<K, V>> init) {
        return get(namespace, init, false);
    }

    @SuppressWarnings("unchecked")
    public static <K, V> InMemoryCache<K, V> get(String namespace, Consumer<InMemoryCache<K, V>> init, boolean sync) {
        final AtomicReference<InMemoryCache<K, V>> inMemoryCache =
                new AtomicReference<>((InMemoryCache<K, V>) CACHE_MAP.get(namespace));
        boolean isNull = false;
        if (inMemoryCache.get() == null) {
            isNull = true;
            inMemoryCache.set((new InMemoryCache<>(namespace)));
            CACHE_MAP.put(namespace, inMemoryCache.get());
        }

        if (isNull && init != null) {
            if (sync) {
                init.accept(inMemoryCache.get());
            } else {
                ThreadUtils.executor(() -> init.accept(inMemoryCache.get()));
            }
        }
        return inMemoryCache.get();
    }


    public static <K, V> InMemoryCache<K, V> get() {
        return get(DEFAULT_NAMESPACE);
    }
}
