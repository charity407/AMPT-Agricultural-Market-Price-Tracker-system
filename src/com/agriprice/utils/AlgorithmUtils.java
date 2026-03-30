package com.agriprice.utils;

import java.util.List;

/**
 * Utility class containing various search and sorting algorithms
 * implemented in Java for the AgriPrice KE system.
 */
public class AlgorithmUtils {

    /**
     * Linear Search Algorithm
     * Searches for a target product name in a list of product names.
     * Time Complexity: O(n)
     * Space Complexity: O(1)
     *
     * @param products List of product names
     * @param target   The product name to search for
     * @return Index of the target if found, -1 otherwise
     */
    public static int linearSearch(List<String> products, String target) {
        for (int i = 0; i < products.size(); i++) {
            if (products.get(i).equalsIgnoreCase(target)) {
                return i;
            }
        }
        return -1;
    }

    /**
     * Binary Search Algorithm
     * Searches for a target product name in a sorted list of product names.
     * Assumes the list is sorted alphabetically (case-insensitive).
     * Time Complexity: O(log n)
     * Space Complexity: O(1)
     *
     * @param products Sorted list of product names
     * @param target   The product name to search for
     * @return Index of the target if found, -1 otherwise
     */
    public static int binarySearch(List<String> products, String target) {
        int left = 0;
        int right = products.size() - 1;

        while (left <= right) {
            int mid = left + (right - left) / 2;
            int comparison = products.get(mid).compareToIgnoreCase(target);

            if (comparison == 0) {
                return mid;
            } else if (comparison < 0) {
                left = mid + 1;
            } else {
                right = mid - 1;
            }
        }
        return -1;
    }

    /**
     * Bubble Sort Algorithm
     * Sorts a list of prices in ascending order.
     * Time Complexity: O(n^2) worst case, O(n) best case (already sorted)
     * Space Complexity: O(1)
     *
     * @param prices List of double prices to sort
     */
    public static void bubbleSort(List<Double> prices) {
        int n = prices.size();
        boolean swapped;

        for (int i = 0; i < n - 1; i++) {
            swapped = false;
            for (int j = 0; j < n - i - 1; j++) {
                if (prices.get(j) > prices.get(j + 1)) {
                    // Swap
                    double temp = prices.get(j);
                    prices.set(j, prices.get(j + 1));
                    prices.set(j + 1, temp);
                    swapped = true;
                }
            }
            // If no swaps occurred, array is sorted
            if (!swapped)
                break;
        }
    }

    /**
     * Quick Sort Algorithm
     * Sorts a list of prices in ascending order using divide and conquer.
     * Time Complexity: O(n log n) average, O(n^2) worst case
     * Space Complexity: O(log n) due to recursion
     *
     * @param prices List of double prices to sort
     * @param low    Starting index
     * @param high   Ending index
     */
    public static void quickSort(List<Double> prices, int low, int high) {
        if (low < high) {
            int pivotIndex = partition(prices, low, high);
            quickSort(prices, low, pivotIndex - 1);
            quickSort(prices, pivotIndex + 1, high);
        }
    }

    private static int partition(List<Double> prices, int low, int high) {
        double pivot = prices.get(high);
        int i = low - 1;

        for (int j = low; j < high; j++) {
            if (prices.get(j) <= pivot) {
                i++;
                // Swap
                double temp = prices.get(i);
                prices.set(i, prices.get(j));
                prices.set(j, temp);
            }
        }

        // Swap pivot
        double temp = prices.get(i + 1);
        prices.set(i + 1, prices.get(high));
        prices.set(high, temp);

        return i + 1;
    }

    /**
     * Simple Price Comparison Algorithm
     * Finds the minimum and maximum prices in a list.
     * Time Complexity: O(n)
     * Space Complexity: O(1)
     *
     * @param prices List of prices
     * @return Array with [min, max] prices
     */
    public static double[] findMinMaxPrices(List<Double> prices) {
        if (prices.isEmpty()) {
            return new double[] { 0.0, 0.0 };
        }

        double min = prices.get(0);
        double max = prices.get(0);

        for (double price : prices) {
            if (price < min)
                min = price;
            if (price > max)
                max = price;
        }

        return new double[] { min, max };
    }
}
