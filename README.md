# Litestream Base

Add this to an existing Dockerfile as a stage:


```Dockerfile
FROM flyio/litestream-base as litestream
```

Then, add these lines to the final stage:

```Dockerfile
## near the top of your dockerfile
COPY --from=litestream /litestream /litestream


# Replace your CMD with the litestream wrapper command

CMD [ "/litestream/start.sh" , "<your-CMD>"]
```