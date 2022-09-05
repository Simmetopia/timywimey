<script lang="ts">
  import { UserDetailsProps } from "./types";
  export let request;
  export let user: UserDetailsProps;
  $: wk = user.details.weekly_hours;
  $: nName = user.details.name;
  function submit() {
    console.log("submitting:", { wk, nName });
    request("fe_save", { wk, nName }, console.log);
  }
</script>

<div class="flex flex-col gap-3">
  <span>
    user {user.user.email}
  </span>
  <span>
    with name {user.details.name}
  </span>
  <span>
    works {user.details.weekly_hours} pr week
  </span>

  <form on:submit|preventDefault={submit} class="flex flex-col gap-3">
    <input
      class="border border-slate-400 rounded px-3"
      placeholder={user.details.weekly_hours.toString()}
      name="weekly_hours"
      bind:value={wk}
    />
    <input
      name="name"
      placeholder={user.details.name}
      class="border border-slate-400 rounded px-3"
      bind:value={nName}
    />
    <button type="submit"> Edit</button>
  </form>
</div>
