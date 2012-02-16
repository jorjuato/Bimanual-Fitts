function centroids =  getBarCentroids(x)
    [r,c] =size(x);
    centroids = zeros(1,c);
    for i=1:c
        centroids(c-i+1) = sum(x(:,i)/r);
    end
end