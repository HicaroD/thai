<script lang="ts">
  import type { HTMLAttributes } from "svelte/elements";
  import {
    cn,
    type WithElementRef,
  } from "$lib/features/shared/components/_shadcn/utils.js";

  let {
    ref = $bindable(null),
    class: className,
    children,
    ...restProps
  }: WithElementRef<HTMLAttributes<HTMLParagraphElement>> = $props();
</script>

<p
  bind:this={ref}
  data-slot="card-description"
  class={cn("text-muted-foreground text-sm", className)}
  {...restProps}
>
  {@render children?.()}
</p>
