if ! command -v doctl >/dev/null; then
  warning "DigitalOcean CLI (doctl) not found."
fi
# if ! [ -f ~/.config/doctl/ ]; then
#   warning "~/.config/doctl not found. Maybe auth or test cli first."
# fi

# To view available regions: "doctl compute region list"
DIGITALOCEAN_REGION=${DIGITALOCEAN_REGION-nyc3}

# To view available types: "doctl compute size list"
DIGITALOCEAN_SIZE=${DIGITALOCEAN_SIZE-s-2vcpu-4gb}

# To view available images: "doctl compute image list --public"
DIGITALOCEAN_IMAGE=${DIGITALOCEAN_IMAGE-ubuntu-20-04-x64}

infra_list() {
    doctl compute droplet list --format ID,Name,Status,Image,Tags
}

infra_start() {
    # doctl auth init

    COUNT=$1

    for I in $(seq 1 $COUNT); do
        NAME=$(printf "%s-%03d" $TAG $I)
        sep "Starting instance $I/$COUNT"
        info "        Region: $DIGITALOCEAN_REGION"
        info "          Name: $NAME"
        info " Droplet  Size: $DIGITALOCEAN_SIZE"
        MAX_TRY=5
        TRY=1
        WAIT=1
        while ! doctl compute droplet create \
            ${NAME} \
            --wait \
            --format ID,Name,Image,PublicIPv4 \
            --size=${DIGITALOCEAN_SIZE} \
            --region=${DIGITALOCEAN_REGION} \
            --image=${DIGITALOCEAN_IMAGE} \
            --ssh-keys=${DIGITALOCEAN_SSHKEY} \
            --tag-name=${TAG}; do
              warning "Failed to create VM (attempt $TRY/$MAX_TRY)."
              if [ $TRY -ge $MAX_TRY ]; then
                  die "Giving up."
              fi
              info "Waiting $WAIT seconds and retrying."
              sleep $WAIT
              TRY=$(($TRY+1))
              WAIT=$(($WAIT*2))
            done
    done
    sep

    get_ips_by_tag $TAG > tags/$TAG/ips.txt
}

infra_stop() {
    info "Counting instances..."
    get_ids_by_tag $TAG | wc -l
    info "Deleting instances..."
    get_ids_by_tag $TAG | 
        xargs -n1 -P10 \
        doctl compute droplet delete -f
}

get_ids_by_tag() {
    TAG=$1
    doctl compute droplet list --tag-name $TAG --no-header --format ID
}

get_ips_by_tag() {
    TAG=$1
    doctl compute droplet list --tag-name $TAG --no-header --format PublicIPv4
}
