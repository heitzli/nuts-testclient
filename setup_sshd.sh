if [ -n "${ADMIN_PASSWORD-}" ]; then
    echo "user:$ADMIN_PASSWORD" | chpasswd
fi

ssh-keygen -A